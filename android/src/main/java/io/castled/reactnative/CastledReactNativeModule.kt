// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.Manifest
import android.app.Application
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.CastledUserAttributes
import io.castled.android.notifications.push.models.PushTokenType
import io.castled.reactnative.extensions.toCastledConfigs
import io.castled.reactnative.extensions.toMap
import io.castled.reactnative.listeners.CastledReactNativePushNotificationListener

class CastledReactNativeModule internal constructor(context: ReactApplicationContext) :
  CastledReactNativeModuleSpec(context) {

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
  override fun requestPushPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      val permissionState =
        ContextCompat.checkSelfPermission(
          reactApplicationContext,
          Manifest.permission.POST_NOTIFICATIONS
        )
      // If the permission is not granted, request it.
      if (permissionState == PackageManager.PERMISSION_DENIED) {
        reactApplicationContext.currentActivity?.let {
          ActivityCompat.requestPermissions(
            it,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1
          )
        }
      }
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
}
