package io.castled.reactnative.listeners

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.CastledPushNotificationListener
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.android.notifications.push.models.CastledPushMessage
import io.castled.reactnative.consts.CastledEmitterKeys
import io.castled.reactnative.utils.CastledEmitterUtils

internal class CastledReactNativePushNotificationListener(private val reactApplicationContext: ReactApplicationContext) {

  @Synchronized
  fun startListeningToPush() {
    if (isListenerInitialized) {
      return
    }
    isListenerInitialized = true
    CastledNotifications.subscribeToPushNotificationEvents(object :
      CastledPushNotificationListener {

      // Push received
      override fun onCastledPushReceived(pushMessage: CastledPushMessage) {
        sendPushEventWith(
          CastledEmitterKeys.PUSH_NOTIFICATION_RECEIVED.value,
          CastledEmitterUtils.getPushReceivedOrDismissedPayload(pushMessage)
        )
      }

      // Push clicked
      override fun onCastledPushClicked(
        pushMessage: CastledPushMessage,
        actionContext: CastledActionContext
      ) {

        sendPushEventWith(
          CastledEmitterKeys.PUSH_NOTIFICATION_CLICKED.value,
          CastledEmitterUtils.getPushClickedPayload(pushMessage, actionContext)
        )
      }

      // Push dismissed
      override fun onCastledPushDismissed(pushMessage: CastledPushMessage) {
        sendPushEventWith(
          CastledEmitterKeys.PUSH_NOTIFICATION_DISMISSED.value,
          CastledEmitterUtils.getPushReceivedOrDismissedPayload(pushMessage)
        )
      }
    })
  }


  private fun sendPushEventWith(eventName: String, value: WritableNativeMap) {
    CastledEmitterUtils.sendEventWithName(eventName,value,reactApplicationContext)
    }

  companion object {
    private var instance: CastledReactNativePushNotificationListener? = null
    private var isListenerInitialized: Boolean = false

    @Synchronized
    fun getInstance(context: ReactApplicationContext): CastledReactNativePushNotificationListener {
      if (instance == null) {
        instance = CastledReactNativePushNotificationListener(context)
      }
      return instance!!
    }
  }
}
