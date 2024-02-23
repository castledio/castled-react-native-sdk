package io.castled.reactnative.consts

internal enum class CastledEmitterKeys(val value: String) {
  PUSH_NOTIFICATION_CLICKED("onNotificationClick"),
  PUSH_NOTIFICATION_RECEIVED("onReceivedNotification"),
  PUSH_NOTIFICATION_DISMISSED("onDismissedNotification"),
  IN_APP_MESSAGE_CLICKED("onInAppMessageClick"),
  IN_APP_MESSAGE_RECEIVED("onReceivedInAppMessage"),
  IN_APP_MESSAGE_DISMISSED("onDismissedInAppMessage")
}
