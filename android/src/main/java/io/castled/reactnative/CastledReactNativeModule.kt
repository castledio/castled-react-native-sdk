// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.Manifest
import android.app.Application
import android.content.pm.PackageManager
import android.os.Build
import android.util.SparseArray
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.modules.core.PermissionAwareActivity
import com.facebook.react.modules.core.PermissionListener
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.CastledUserAttributes
import io.castled.android.notifications.push.models.PushTokenType
import io.castled.reactnative.extensions.toCastledConfigs
import io.castled.reactnative.extensions.toMap
import io.castled.reactnative.listeners.CastledReactNativePushNotificationListener

class CastledReactNativeModule internal constructor(context: ReactApplicationContext) :
  CastledReactNativeModuleSpec(context), PermissionListener {

  private val requestPromises = SparseArray<Promise>()
  private var requestCode = 0

  private val pushListener by lazy {
    CastledReactNativePushNotificationListener.getInstance(context)
  }

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun initialize(configs: ReadableMap) {
    val castledConfigs = configs.toCastledConfigs()
    CastledNotifications.initialize(
      reactApplicationContext.applicationContext as Application,
      castledConfigs
    )
    if (castledConfigs.enablePush) {
      pushListener.startListeningToPush()
    }
  }

  @ReactMethod
  override fun setUserId(userId: String, userToken: String?) {
    CastledNotifications.setUserId(reactApplicationContext, userId, userToken)
  }

  @ReactMethod
  override fun logout() {
    CastledNotifications.logout()
  }

  @ReactMethod
  override fun requestPushPermission(promise: Promise) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      val permissionState =
        ContextCompat.checkSelfPermission(
          reactApplicationContext,
          Manifest.permission.POST_NOTIFICATIONS
        )
      if (permissionState == PackageManager.PERMISSION_GRANTED) {
        promise.resolve(true)
      } else {
        // If the permission is not granted, request it.
        try {
          val activity = getPermissionAwareActivity(reactApplicationContext)
          activity.requestPermissions(
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            requestCode,
            this
          )
          requestPromises.put(requestCode, promise)
          requestCode++
        } catch (e: Exception) {
          promise.reject("Push permission request error", e)
        }
      }
    } else {
      promise.resolve(true)
    }
  }

  @ReactMethod
  override fun onTokenFetch(token: String, pushTokenType: String) {
    CastledNotifications.onTokenFetch(token, PushTokenType.valueOf(pushTokenType))
  }

  @ReactMethod
  override fun logCustomAppEvent(eventName: String, eventParams: ReadableMap?) {
    CastledNotifications.logCustomAppEvent(reactApplicationContext, eventName, eventParams.toMap())
  }

  @ReactMethod
  override fun setUserAttributes(attributes: ReadableMap) {
    val attrs = CastledUserAttributes()
    attrs.setAttributes(attributes.toMap())
    CastledNotifications.setUserAttributes(reactApplicationContext, attrs)
  }

  companion object {
    const val NAME = "RTNCastledNotifications"
  }

  @ReactMethod
  override fun addListener(eventType: String?) {
    // Don't Delete: Required for React built in Event Emitter Calls.
  }

  @ReactMethod
  override fun removeListeners(count: Double) {
    // Don't Delete: Required for React built in Event Emitter Calls.
  }

  private fun getPermissionAwareActivity(
    reactContext: ReactApplicationContext
  ): PermissionAwareActivity {
    val activity = reactContext.currentActivity
    checkNotNull(activity) { "Tried to use permissions API while not attached to an " + "Activity." }
    check(activity is PermissionAwareActivity) {
      ("Tried to use permissions API but the host Activity doesn't implement PermissionAwareActivity.")
    }
    return activity
  }

  override fun onRequestPermissionsResult(
    requestCode: Int, permissions: Array<out String>?,
    grantResults: IntArray?
  ): Boolean {
    val promise = requestPromises.get(requestCode)
    if (grantResults?.get(0) == PackageManager.PERMISSION_GRANTED) {
      promise.resolve(true)
    } else {
      promise.resolve(false)
    }
    requestPromises.remove(requestCode)
    return requestPromises.size() == 0
  }
}
