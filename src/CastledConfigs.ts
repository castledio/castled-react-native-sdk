// Enum values based on the Kotlin XiaomiRegion enum
enum CastledLocation {
  US, // United States
  EU, // Europe
  IN, // India
  AP, // Asia Pacific
  TEST, // Test
}

enum XiaomiRegion {
  Global, // United States
  India, // Europe
  Europe, // India
}

enum PushTokenType {
  FCM,
  MI_PUSH
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

export { CastledLocation, XiaomiRegion, PushTokenType, CastledConfigs };
