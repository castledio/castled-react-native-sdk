//
//  RTNCastledEventEmitter.m
//  castled-react-native-sdk
//
//  Created by antony on 12/01/2024.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCastledReactNativeSdkSpec.h"
@interface RCT_EXTERN_MODULE(RTNCastledEventEmitter, NSObject<NativeCastledNotificationsSpec>)
#else
@interface RCT_EXTERN_MODULE(RTNCastledEventEmitter, RCTEventEmitter)
#endif

RCT_EXTERN_METHOD(supportedEvents)

RCT_EXTERN_METHOD(handleReceivedNotification:(NSDictionary *)userInfo)

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeCastledNotificationsSpecJSI>(params);
}
#endif

@end
