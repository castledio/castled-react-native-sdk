package io.castled.reactnative.listeners

import com.facebook.react.bridge.ReactApplicationContext
import io.castled.android.notifications.CastledNotifications
import io.castled.android.notifications.inapp.CastledInappNotificationListener
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.reactnative.consts.CastledEmitterKeys
import io.castled.reactnative.extensions.toWriteableNativeMap
import io.castled.reactnative.utils.CastledEmitterUtils

internal class CastledReactNativeInAppListener(private val reactApplicationContext: ReactApplicationContext) {

  @Synchronized
  fun startListeningToInAppEvents() {
    if (isListenerInitialized) {
      return
    }
    isListenerInitialized = true
    // Listening to inapp notification clicks
    CastledNotifications.subscribeToInappEvents(object :
      CastledInappNotificationListener {
      override fun onCastledInappClicked(actionContext: CastledActionContext) {
        CastledEmitterUtils.sendEventWithName(
          CastledEmitterKeys.IN_APP_MESSAGE_CLICKED.value,
          actionContext.toWriteableNativeMap(),reactApplicationContext)
      }

    })
  }


  companion object {
    private var instance: CastledReactNativeInAppListener? = null
    private var isListenerInitialized: Boolean = false

    @Synchronized
    fun getInstance(context: ReactApplicationContext): CastledReactNativeInAppListener {
      if (instance == null) {
        instance = CastledReactNativeInAppListener(context)
      }
      return instance!!
    }
  }
}
