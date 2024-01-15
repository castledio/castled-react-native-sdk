
// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.push.models.PushTokenType
import io.castled.reactnative.extensions.toCastledConfigs
import io.castled.reactnative.extensions.toMap

class CastledReactNativeModule internal constructor(context: ReactApplicationContext) :
  CastledReactNativeModuleSpec(context) {

  override fun getName(): String {
     return NAME
  }

  @ReactMethod
  override fun initialize(configs: ReadableMap) {
      CastledNotifications.initialize(reactApplicationContext.applicationContext as Application, configs.toCastledConfigs())
  }

  @ReactMethod
  override fun  setUserId(userId: String, userToken: String?) {
      CastledNotifications.setUserId(reactApplicationContext, userId, userToken)
  }

  @ReactMethod
  override fun logout() {
      CastledNotifications.logout(reactApplicationContext)
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
      // TODO
      // CastledNotifications.setUserAttributes(reactApplicationContext, attributes.toMap())
  }

  companion object {
      const val NAME = "RTNCastledNotifications"
  }


}
