package io.castled.reactnative.consts

import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeArray
import com.facebook.react.bridge.WritableNativeMap
import io.castled.android.notifications.push.models.CastledActionButton
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.android.notifications.push.models.CastledClickAction
import io.castled.android.notifications.push.models.CastledPushMessage

internal class CastledEmitterUtils {
  companion object {
    private const val NOTIFICATION = "notification"
    private const val CLICK_ACTION = "clickAction"

    fun getPushClickedPayload(
      pushMessage: CastledPushMessage,
      clickAction: CastledActionContext
    ): WritableNativeMap {
      val payload = WritableNativeMap()
      payload.putMap(NOTIFICATION, pushMessage.toNotificationObject())
      payload.putMap(CLICK_ACTION, clickAction.toClickAction())
      return payload
    }

    fun getPushReceivedOrDismissedPayload(
      notification: CastledPushMessage
    ): WritableNativeMap {
      return notification.toNotificationObject()
    }

    private fun CastledActionContext.toClickAction(): WritableNativeMap {
      val action = WritableNativeMap()
      action.putString("buttonTitle", actionLabel ?: "")
      var actionTypeString = "DEFAULT"
      actionType?.let { actionTypeString = it.toString() }
      action.putString("actionType", actionTypeString)
      action.putString("clickActionUri", actionUri)
      keyVals?.let { action.putMap("keyVals", it.toWritableMap()) }
      return action
    }

    private fun CastledPushMessage.toNotificationObject(): WritableNativeMap {
      val notification = WritableNativeMap()
      notification.putString("title", title ?: "")
      notification.putString("body", body ?: "")
      notification.putString("sound", sound ?: "")
      notification.putString("notificationId", notificationId.toString())
      notification.putString("summary", summary ?: "")
      notification.putString("channelId", channelId ?: "")
      notification.putString("channelName", channelName ?: "")
      notification.putString("channelDescription", channelDescription ?: "")
      notification.putString("channelDescription", channelDescription ?: "")
      notification.putString("smallIconResourceId", smallIconResourceId ?: "")
      notification.putString("largeIconUri", largeIconUri ?: "")
      ttl?.let { notification.putDouble("notificationId", it.toDouble()) }
      actionButtons?.let { notification.putArray("actionButtons", it.toWritableArray()) }
      inboxCopyEnabled?.let { notification.putBoolean("inboxCopyEnabled", it) }
      return notification
    }

    private fun List<CastledActionButton>.toWritableArray(): WritableArray {
      val actionsArray: WritableArray = WritableNativeArray()
      forEach { item ->
        val buttonMap: WritableMap = WritableNativeMap()
        buttonMap.putString("buttonTitle", item.label)
        buttonMap.putString("clickActionUri", item.url)
        buttonMap.putString("actionType", item.clickAction.stringValue())
        item.keyVals?.let { buttonMap.putMap("keyVals", it.toWritableMap()) }
        actionsArray.pushMap(buttonMap)
      }
      return actionsArray
    }

    private fun HashMap<String, String>.toWritableMap(): WritableMap {
      val writableMap: WritableMap = WritableNativeMap()
      for ((key, value) in this) {
        writableMap.putString(key, value)
      }
      return writableMap
    }

    private fun Map<String, String>.toWritableMap(): WritableMap {
      val writableMap: WritableMap = WritableNativeMap()
      for ((key, value) in this) {
        writableMap.putString(key, value)
      }
      return writableMap
    }

    private fun CastledClickAction.stringValue(): String {
      return this.name
    }
  }
}
