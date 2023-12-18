package io.castled.reactnative

import com.facebook.react.bridge.ReactApplicationContext

abstract class CastledReactNativeSdkSpec internal constructor(context: ReactApplicationContext) :
  NativeCastledReactNativeSdkSpec(context) {
}
