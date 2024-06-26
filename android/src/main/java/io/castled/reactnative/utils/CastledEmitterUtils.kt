package io.castled.reactnative.utils

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.android.notifications.push.models.CastledPushMessage
import io.castled.reactnative.extensions.toWriteableNativeMap

internal object CastledEmitterUtils {

  private const val NOTIFICATION = "notification"
  private const val CLICK_ACTION = "clickAction"

  fun getPushClickedPayload(
    pushMessage: CastledPushMessage,
    clickAction: CastledActionContext
  ): WritableNativeMap {
    val payload = WritableNativeMap()
    payload.putMap(NOTIFICATION, pushMessage.toWriteableNativeMap())
    payload.putMap(CLICK_ACTION, clickAction.toWriteableNativeMap())
    return payload
  }

  fun getPushReceivedOrDismissedPayload(
    notification: CastledPushMessage
  ): WritableNativeMap {
    return notification.toWriteableNativeMap()
  }
   fun sendEventWithName(eventName: String, value: WritableNativeMap, reactApplicationContext: ReactApplicationContext) {
    reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, value)
  }

}
