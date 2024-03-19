//
//  CastledReactBridge.m
//  RTNCastledNotifications
//
//  Created by antony on 02/01/2024.
//

#import "CastledReactBridge.h"
#ifdef __has_include
    #if __has_include(<castled_react_native_sdk/castled_react_native_sdk-Swift.h>)
        #import <castled_react_native_sdk/castled_react_native_sdk-Swift.h>
    #else
        #import "castled_react_native_sdk-Swift.h"
    #endif
#else
    #import "castled_react_native_sdk-Swift.h"
#endif
static CastledReactBridge *sharedInstance = nil;
@interface CastledReactBridge() {

}
@end

@implementation CastledReactBridge

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+(CastledReactBridge *) sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setPushToken:(NSString *)token{
    [RTNCastledNotifications onTokenFetch:token];
 }

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response{
    [RTNCastledNotifications userNotificationCenter:center didReceive:response];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification{
    [RTNCastledNotifications userNotificationCenter:center willPresent:notification];
}

- (void)didReceiveRemoteNotificationInApplication:(UIApplication *)application withInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    [RTNCastledNotifications didReceiveRemoteNotificationInApplication:application withInfo:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
    }];
}

- (void)setNotificationCategoriesWithItems:(NSSet<UNNotificationCategory *> *)items{
    [RTNCastledNotifications setNotificationCategoriesWithItems:items];
}

- (void)setLaunchOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> * )launchOptions {
    if (launchOptions) {
        [RTNCastledNotifications setLaunchOptionsWithLaunchOptions:launchOptions];
    }
}

@end
