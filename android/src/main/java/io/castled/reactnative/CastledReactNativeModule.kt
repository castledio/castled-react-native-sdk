// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.CastledUserAttributes
import io.castled.android.notifications.push.models.PushTokenType
import io.castled.reactnative.consts.ConfigKeys
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
    CastledNotifications.initialize(
      reactApplicationContext.applicationContext as Application,
      configs.toCastledConfigs()
    )
    if (configs.hasKey(ConfigKeys.ENABLE_PUSH) && configs.getBoolean(ConfigKeys.ENABLE_PUSH)) {
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
  fun addListener(eventType: String?) {
    // Don't Delete: Required for React built in Event Emitter Calls.

  }

  @ReactMethod
  fun removeListeners(count: Double) {
    // Don't Delete: Required for React built in Event Emitter Calls.

  }
}
