package io.castled.reactnative

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext

abstract class CastledReactNativeModuleSpec internal constructor(context: ReactApplicationContext) :
  NativeCastledNotificationsSpec(context) {

}
