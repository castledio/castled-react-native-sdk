import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

export type CastledEventParams = { [key: string]: string | number | boolean };

export type CastledCustomAttributes = {
  [key: string]: string | number | boolean;
};

export enum CastledClickActionType {
  DEEP_LINKING = 'DEEP_LINKING',
  NAVIGATE_TO_SCREEN = 'NAVIGATE_TO_SCREEN',
  RICH_LANDING = 'RICH_LANDING',
  REQUEST_PUSH_PERMISSION = 'REQUEST_PUSH_PERMISSION',
  DISCARD_NOTIFICAION = 'DISMISS_NOTIFICATION',
  DEFAULT = 'DEFAULT',
  CUSTOM = 'CUSTOM',
  NONE = 'NONE',
}

export enum CastledEvents {
  PUSH_NOTIFICATION_CLICKED = 'onNotificationClick',
  PUSH_NOTIFICATION_RECEIVED = 'onReceivedNotification',
  PUSH_NOTIFICATION_DISMISSED = 'onDismissedNotification',
  IN_APP_MESSAGE_CLICKED = 'onInAppMessageClick',
}

export type CastledPushNotificationClickEvent = {
  clickAction?: CastledClickAction;
  notification: CastledPushNotification;
};

export type CastledClickAction = {
  actionType: CastledClickActionType;
  buttonTitle?: string;
  clickActionUri?: string;
  keyVals?: CastledCustomAttributes;
};

export type CastledPushNotification = {
  title?: string;
  body: string;
  sound: string;
  actionButtons?: CastledClickAction[];
  notificationId: string;

  // iOS
  badge?: string;
  category?: string;
  contentAvailable?: string;
  interruptionLevel?: string;
  mutableContent?: boolean;
  relevanceScore?: number;
  shouldIncrementBadge?: boolean;
  subtitle?: string;
  threadId?: string;

  // Android
  channelId?: string;
  channelName?: string;
  channelDescription?: string;
  smallIconResourceId?: string;
  largeIconUri?: string;
  summary?: string;
  ttl?: Double;
};
