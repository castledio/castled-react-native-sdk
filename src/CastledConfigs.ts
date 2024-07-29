// Enum values based on the Kotlin XiaomiRegion enum
enum CastledLocation {
  US = 'US', // United States
  TEST = 'TEST', // Test
}

enum CastledLogLevel {
  NONE = 'none',
  ERROR = 'error',
  INFO = 'info',
  DEBUG = 'debug',
}

enum XiaomiRegion {
  Global = 'Global', // United States
  India = 'India', // India
  Europe = 'Europe', // Europe
}

enum CastledPushTokenType {
  FCM = 'FCM',
  MI_PUSH = 'MI_PUSH',
  APNS = 'APNS',
}

class CastledConfigs {
  appId: string = '';
  location: CastledLocation = CastledLocation.US;
  enablePush: boolean = false;
  enablePushBoost: boolean = false;
  enableInApp: boolean = false;
  enableTracking: boolean = false;
  enableAppInbox: boolean = false;
  enableSessionTracking: boolean = true;
  skipUrlHandling: boolean = false;
  inAppFetchIntervalSec: number = 3600;
  inBoxFetchIntervalSec: number = 3600;
  sessionTimeOutSec: number = 900;
  xiaomiAppId: string = '';
  xiaomiAppKey: string = '';
  xiaomiRegion: XiaomiRegion = XiaomiRegion.Global;
  permittedBGIdentifier: string = '';
  appgroupId: string = '';
  logLevel: CastledLogLevel = CastledLogLevel.DEBUG;
}
class CastledInboxConfigs {
  emptyMessageViewText: string =
    'We have no updates. Please check again later.';
  emptyMessageViewTextColor: string = '#000000';
  inboxViewBackgroundColor: string = '#ffffff';
  navigationBarBackgroundColor: string = '#ffffff';
  navigationBarTitle: string = 'App Inbox';
  navigationBarTitleColor: string = '#ffffff';
  hideNavigationBar: boolean = false;
  hideBackButton: boolean = false;
  backButtonResourceId: number = -1; // android
  backButtonImage: string = ''; // ios

  // Tabbar Configuraitions
  showCategoriesTab: boolean = true;
  tabBarDefaultBackgroundColor: string = '#ffffff';
  tabBarSelectedBackgroundColor: string = '#ffffff';
  tabBarDefaultTextColor: string = '#000000';
  tabBarSelectedTextColor: string = '#3366CC';
  tabBarIndicatorBackgroundColor: string = '#3366CC';
}
export {
  CastledLocation,
  XiaomiRegion,
  CastledPushTokenType,
  CastledConfigs,
  CastledInboxConfigs,
  CastledLogLevel,
};
