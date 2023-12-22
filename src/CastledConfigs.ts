// Enum values based on the Kotlin XiaomiRegion enum
enum CastledLocation {
  US = 'US', // United States
  TEST = 'TEST', // Test
}

enum XiaomiRegion {
  Global = 'Global', // United States
  India = 'India', // India
  Europe = 'Europe', // Europe
}

enum CastledPushTokenType {
  FCM = 'FCM',
  MI_PUSH = 'MI_PUSH',
}

class CastledConfigs {
  appId: string = '';
  location: CastledLocation = CastledLocation.US;
  enablePush: boolean = false;
  enablePushBoost: boolean = false;
  enableInApp: boolean = false;
  enableTracking: boolean = false;
  enableAppInbox: boolean = false;
  inAppFetchIntervalSec: number = 3600;
  inBoxFetchIntervalSec: number = 3600;
  xiaomiAppId: string = '';
  xiaomiAppKey: string = '';
  xiaomiRegion: XiaomiRegion = XiaomiRegion.Global;
}

export { CastledLocation, XiaomiRegion, CastledPushTokenType, CastledConfigs };
