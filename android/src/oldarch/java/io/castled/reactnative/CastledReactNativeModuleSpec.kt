// NativeCastledNotificationsSpec

package io.castled.reactnative

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Promise

abstract class CastledReactNativeModuleSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {

  abstract fun initialize(configs: ReadableMap)

  abstract fun setUserId(userId: String, userToken: String?)

  abstract fun logout()

  abstract fun onTokenFetch(token: String, pushTokenType: String)

  abstract fun logCustomAppEvent(eventName: String, eventParams: ReadableMap?)

  abstract fun setUserAttributes(attributes: ReadableMap)

  abstract fun requestPushPermission(promise: Promise)

  abstract fun removeListeners(count: Double)

  abstract fun addListener(eventType: String?)


}
