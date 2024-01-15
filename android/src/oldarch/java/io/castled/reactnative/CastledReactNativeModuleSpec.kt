
// NativeCastledNotificationsSpec

package io.castled.reactnative

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import io.castled.android.notifications.push.models.PushTokenType

abstract class CastledReactNativeModuleSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {

  abstract fun initialize(configs: ReadableMap)

  abstract fun setUserId(userId: String, userToken: String?)

  abstract fun logout()

  abstract fun onTokenFetch(token: String, pushTokenType: String)

  abstract fun logCustomAppEvent(eventName: String, eventParams: ReadableMap?)

  abstract fun setUserAttributes(attributes: ReadableMap)

}
