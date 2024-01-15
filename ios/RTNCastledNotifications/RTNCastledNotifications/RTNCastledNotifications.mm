//
//  CastledReactNativeSdk.m
//  CastledReactNativeSdk
//
//  Created by antony on 20/12/2023.
//

#import <React/RCTBridgeModule.h>

/* Argument types cheatsheet
 * | Objective C                                   | JavaScript         |
 * **********************************************************************
 * | NSString                                      | string, ?string    |
 * | BOOL                                          | boolean            |
 * | NSNumber                                      | ?boolean           |
 * | double                                        | number             |
 * | NSNumber                                      | ?number            |
 * | NSArray                                       | Array, ?Array      |
 * | NSDictionary                                  | Object, ?Object    |
 * | RCTResponseSenderBlock                        | Function (success) |
 * | RCTResponseSenderBlock, RCTResponseErrorBlock | Function (failure) |
 * | RCTPromiseResolveBlock, RCTPromiseRejectBlock | Promise            |
 ************************************************************************

 */


#ifdef RCT_NEW_ARCH_ENABLED
#import "RNCastledReactNativeSdkSpec.h"
@interface RCT_EXTERN_MODULE(RTNCastledNotifications, NSObject<NativeCastledNotificationsSpec>)
#else
@interface RCT_EXTERN_MODULE(RTNCastledNotifications, NSObject<RCTBridgeModule>)
#endif

RCT_EXTERN_METHOD(initialize:(NSDictionary *)configs)
RCT_EXTERN_METHOD(setUserId:(NSString *)userId userToken:(NSString *)userToken);
RCT_EXTERN_METHOD(logCustomAppEvent:(NSString *)eventName eventParams:(NSDictionary *)eventParams);
RCT_EXTERN_METHOD(setUserAttributes:(NSDictionary *)attributes);
RCT_EXTERN_METHOD(onTokenFetch:(NSString *)token);
RCT_EXTERN_METHOD(logout);
RCT_EXTERN_METHOD(userNotificationCenter:(NSDictionary *)userInfo);
RCT_EXTERN_METHOD(willPresentNotification:(NSDictionary *)notificationInfo);
RCT_EXTERN_METHOD(didReceiveRemoteNotificationInApplication:(NSDictionary *)notificationInfo completionHandler:(RCTResponseSenderBlock)completionHandler);
RCT_EXTERN_METHOD(setNotificationCategoriesWithItems:(NSSet<UNNotificationCategory *> *)items)
RCT_EXTERN_METHOD(setLaunchOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions)

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeCastledNotificationsSpecJSI>(params);
}
#endif

@end
/*

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
*/
