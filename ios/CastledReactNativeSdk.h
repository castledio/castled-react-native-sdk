
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCastledReactNativeSdkSpec.h"

@interface CastledReactNativeSdk : NSObject <NativeCastledReactNativeSdkSpec>
#else
#import <React/RCTBridgeModule.h>

@interface CastledReactNativeSdk : NSObject <RCTBridgeModule>
#endif

@end
