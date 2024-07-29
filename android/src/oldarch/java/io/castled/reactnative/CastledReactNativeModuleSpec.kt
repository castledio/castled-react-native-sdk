// NativeCastledNotificationsSpec

package io.castled.reactnative

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReadableMap

abstract class CastledReactNativeModuleSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {

  abstract fun initialize(configs: ReadableMap)

  abstract fun setUserId(userId: String, userToken: String?)

  abstract fun logout()

  abstract fun onTokenFetch(token: String, pushTokenType: String)

  abstract fun logCustomAppEvent(eventName: String, eventParams: ReadableMap?)

  abstract fun logPageViewedEvent(screenName:String)

  abstract fun pauseInApp()

  abstract fun resumeInApp()

  abstract fun stopInApp()

  abstract fun setUserAttributes(attributes: ReadableMap)

  abstract fun requestPushPermission(promise: Promise)

  abstract fun getPushPermission(promise: Promise)

  abstract fun removeListeners(count: Double)

  abstract fun addListener(eventType: String?)

  abstract fun showAppInbox(configs: ReadableMap?)

  abstract fun getInboxUnreadCount(promise: Promise)
}
