export type CastledEventParams = { [key: string]: string | number | boolean };
export declare type CastledNotificationEvent = {
  clickAction?: CastledClickAction;
  notification: CastledNotification;
};

enum CastledClickActionType {
  deepLink,
  navigateToScreen,
  richLanding,
  requestPushPermission,
  discardNotification,
  custom,
  none,
}
export declare type CastledClickAction = {
  clickActionUri?: string;
  actionType: CastledClickActionType;
  keyVals?: CastledEventParams;
};

export declare type CastledNotification = {
  title?: string;
  body: string;
  sound: string;
  actionButtons?: CastledEventParams[];
  notificationId: string;

  // iOS
  attachments?: CastledEventParams[];
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
  groupKey?: string;
  groupMessage?: string;
  ledColor?: string;
  priority?: number;
  smallIcon?: string;
  largeIcon?: string;
  bigPicture?: string;
  collapseId?: string;
  fromProjectNumber?: string;
  smallIconAccentColor?: string;
  lockScreenVisibility?: string;
  androidNotificationId?: number;
};
