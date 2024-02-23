package io.castled.reactnative.extensions

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeArray
import com.facebook.react.bridge.WritableNativeMap
import io.castled.android.notifications.CastledConfigs
import io.castled.android.notifications.push.models.CastledActionButton
import io.castled.android.notifications.push.models.CastledActionContext
import io.castled.android.notifications.push.models.CastledClickAction
import io.castled.android.notifications.push.models.CastledPushMessage
import io.castled.reactnative.consts.ConfigKeys

internal fun ReadableMap?.toMap(): Map<String, Any> {
  return this?.toHashMap() ?: emptyMap()
}

internal fun ReadableMap.toCastledConfigs(): CastledConfigs {
  return CastledConfigs.Builder()
    .appId(getString(ConfigKeys.APP_ID)!!)
    .location(
      getString(ConfigKeys.LOCATION)?.let {
        CastledConfigs.CastledLocation.valueOf(it)
      }
        ?: CastledConfigs.CastledLocation.US
    )
    .enablePush(
      if (hasKey(ConfigKeys.ENABLE_PUSH)) getBoolean(ConfigKeys.ENABLE_PUSH)
      else false
    )
    .enablePushBoost(
      if (hasKey(ConfigKeys.ENABLE_PUSH_BOOST))
        getBoolean(ConfigKeys.ENABLE_PUSH_BOOST)
      else false
    )
    .enableAppInbox(
      if (hasKey(ConfigKeys.ENABLE_APP_INBOX)) getBoolean(ConfigKeys.ENABLE_APP_INBOX)
      else false
    )
    .enableInApp(
      if (hasKey(ConfigKeys.ENABLE_IN_APP)) getBoolean(ConfigKeys.ENABLE_IN_APP)
      else false
    )
    .enableTracking(
      if (hasKey(ConfigKeys.ENABLE_TRACKING)) getBoolean(ConfigKeys.ENABLE_TRACKING)
      else false
    )
    .enableSessionTracking(
      if (hasKey(ConfigKeys.ENABLE_SESSION_TRACKING))
        getBoolean(ConfigKeys.ENABLE_SESSION_TRACKING)
      else true
    )
    .skipUrlHandling(
      if (hasKey(ConfigKeys.SKIP_URL_HANDLING))
        getBoolean(ConfigKeys.SKIP_URL_HANDLING)
      else false
    )
    .inAppFetchIntervalSec(
      if (hasKey(ConfigKeys.IN_APP_FETCH_INTERVAL))
        getDouble(ConfigKeys.IN_APP_FETCH_INTERVAL).toLong()
      else 600L
    )
    .inBoxFetchIntervalSec(
      if (hasKey(ConfigKeys.APP_INBOX_FETCH_INTERVAL))
        getDouble(ConfigKeys.APP_INBOX_FETCH_INTERVAL).toLong()
      else 600L
    )
    .sessionTimeOutSec(
      if (hasKey(ConfigKeys.SESSION_TIMEOUT))
        getDouble(ConfigKeys.SESSION_TIMEOUT).toLong()
      else 900L
    )
    .xiaomiAppId(getString(ConfigKeys.XIAOMI_APP_ID))
    .xiaomiAppKey(getString(ConfigKeys.XIAOMI_APP_KEY))
    .xiaomiRegion(
      getString(ConfigKeys.XIAOMI_APP_REGION)?.let {
        CastledConfigs.XiaomiRegion.valueOf(it)
      }
    )
    .build()
}

internal fun CastledPushMessage.toWriteableNativeMap(): WritableNativeMap {
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
  actionButtons?.let { notification.putArray("actionButtons", it.toWritableNativeArray()) }
  inboxCopyEnabled?.let { notification.putBoolean("inboxCopyEnabled", it) }
  return notification
}

internal fun CastledActionContext.toWriteableNativeMap(): WritableNativeMap {
  val action = WritableNativeMap()
  action.putString("buttonTitle", actionLabel ?: "")
  action.putString("actionType", actionType?.toString() ?: "DEFAULT")
  action.putString("clickActionUri", actionUri)
  keyVals?.let { action.putMap("keyVals", it.toWritableMap()) }
  return action
}

private fun List<CastledActionButton>.toWritableNativeArray(): WritableArray {
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
