//
//  CastledReactNativeSdk.h
//  CastledReactNativeSdk
//
//  Created by antony on 20/12/2023.
//


#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCastledReactNativeSdkSpec.h"

@interface RTNCastledNotifications : NSObject <NativeCastledNotificationsSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RTNCastledNotifications : NSObject <RCTBridgeModule>
#endif

@end
