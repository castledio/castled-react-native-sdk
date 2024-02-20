// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.CastledUserAttributes
import io.castled.android.notifications.push.models.PushTokenType
import io.castled.reactnative.consts.CastledEmitterKeys
import io.castled.reactnative.consts.ConfigKeys
import io.castled.reactnative.extensions.toCastledConfigs
import io.castled.reactnative.extensions.toMap
import io.castled.reactnative.listeners.CastledReactNativePushNotificationListener

class CastledReactNativeModule internal constructor(context: ReactApplicationContext) :
  CastledReactNativeModuleSpec(context) {

  private val pushListener by lazy { CastledReactNativePushNotificationListener.getInstance(context) }

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
    sendPushEvent()
  }

  companion object {
    const val NAME = "RTNCastledNotifications"
  }

  fun sendPushEvent() {
    val notificaiton = HashMap<String, Any>()
    notificaiton.put("title", "Android title")
    notificaiton.put("body", "contentText")
//    val finalNotificaito = HashMap<String, HashMap<String, Any>>()
//    finalNotificaito.put("notificaiton", notificaiton)

    val data = WritableNativeMap().apply {
      putString("title", "Androdi title")
      putString("body", "body")
      putString("summary_text", "summary_text")
    }

    val finalNotificaito = WritableNativeMap()
    finalNotificaito.putMap("notification", data)
    println("sendPushEvent-----------$finalNotificaito")
    reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(CastledEmitterKeys.PUSH_NOTIFICATION_CLICKED.value, finalNotificaito)


  }

  @ReactMethod
  fun startObserving() {
    println("startObserving-----------")

    // Implement startObserving functionality
  }

  @ReactMethod
  fun stopObserving() {
    println("stopObserving-----------")

    // Implement stopObserving functionality
  }

  @ReactMethod
  fun addListener(eventType: String?) {
    eventType?.let {
    }
  }

  @ReactMethod
  fun removeListeners(count: Double) {

  }
}
