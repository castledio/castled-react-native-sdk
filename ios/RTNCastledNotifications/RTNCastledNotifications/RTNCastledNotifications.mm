//
//  CastledReactNativeSdk.m
//  CastledReactNativeSdk
//
//  Created by antony on 20/12/2023.
//

#import "RTNCastledNotifications.h"

@implementation RTNCastledNotifications
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(NSDictionary *)configs) {
    // Extract values from configs dictionary
    // For example, if CtConfigs has properties `property1` and `property2`
    NSLog(@"configs---- %@",configs);


    // Your implementation here
}


// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_EXPORT_METHOD(multiply:(double)a
                  b:(double)b
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(a * b);
    resolve(result);
}




// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeCastledNotificationsSpecJSI>(params);
}
#endif

@end
