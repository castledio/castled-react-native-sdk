//
//  CastledReactNativeSdk.m
//  CastledReactNativeSdk
//
//  Created by antony on 20/12/2023.
//

#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCastledReactNativeSdkSpec.h"
@interface RCT_EXTERN_MODULE(RTNCastledNotifications, RCTEventEmitter<NativeCastledNotificationsSpec>)
#else
#import <React/RCTBridgeModule.h>
@interface RCT_EXTERN_MODULE(RTNCastledNotifications, RCTEventEmitter<RCTBridgeModule>)
#endif

RCT_EXTERN_METHOD(initialize:(NSDictionary *)configs)
RCT_EXTERN_METHOD(setUserId:(NSString *)userId userToken:(NSString *)userToken);
RCT_EXTERN_METHOD(logCustomAppEvent:(NSString *)eventName eventParams:(NSDictionary *)eventParams);
RCT_EXTERN_METHOD(setUserAttributes:(NSDictionary *)attributes);
RCT_EXTERN_METHOD(onTokenFetch:(NSString *)token);
RCT_EXTERN_METHOD(logout);
RCT_EXTERN_METHOD(requestPushPermission: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getPushPermission: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeCastledNotificationsSpecJSI>(params);
}
#endif

@end

