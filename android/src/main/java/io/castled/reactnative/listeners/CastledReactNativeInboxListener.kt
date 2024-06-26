package io.castled.reactnative.listeners

import com.facebook.react.bridge.ReactApplicationContext
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.inbox.CastledInboxListener
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.reactnative.consts.CastledEmitterKeys
import io.castled.reactnative.extensions.toWriteableNativeMap
import io.castled.reactnative.utils.CastledEmitterUtils

internal class CastledReactNativeInboxListener(private val reactApplicationContext: ReactApplicationContext) {

  @Synchronized
  fun startListeningToInboxEvents() {
    if (isListenerInitialized) {
      return
    }
    isListenerInitialized = true
    // Listening to inbox notification clicks
    CastledNotifications.subscribeToInboxEvents(object :
      CastledInboxListener {
      override fun onCastledInboxClicked(actionContext: CastledActionContext) {
        CastledEmitterUtils.sendEventWithName(
          CastledEmitterKeys.INBOX_MESSAGE_CLICKED.value,
          actionContext.toWriteableNativeMap(), reactApplicationContext
        )
      }
    })
  }


  companion object {
    private var instance: CastledReactNativeInboxListener? = null
    private var isListenerInitialized: Boolean = false

    @Synchronized
    fun getInstance(context: ReactApplicationContext): CastledReactNativeInboxListener {
      if (instance == null) {
        instance = CastledReactNativeInboxListener(context)
      }
      return instance!!
    }
  }
}
