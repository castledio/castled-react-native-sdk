//
//  CastledReactBridge.m
//  RTNCastledNotifications
//
//  Created by antony on 02/01/2024.
//

#import "CastledReactBridge.h"
#import "castled_react_native_sdk-Swift.h"
#import <React/RCTEventEmitter.h>

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
    [[RTNCastledNotifications sharedInstance] setPushToken:token];
 }

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response{
    [[RTNCastledNotifications sharedInstance] userNotificationCenter:center didReceive:response];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification{
    [[RTNCastledNotifications sharedInstance] userNotificationCenter:center willPresent:notification];
}

- (void)didReceiveRemoteNotificationInApplication:(UIApplication *)application withInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    [[RTNCastledNotifications sharedInstance] didReceiveRemoteNotificationInApplication:application withInfo:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
    }];
}

- (void)setNotificationCategoriesWithItems:(NSSet<UNNotificationCategory *> *)items{
    [[RTNCastledNotifications sharedInstance] setNotificationCategoriesWithItems:items];
}

- (void)setLaunchOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> * )launchOptions {
    if (launchOptions) {
        [[RTNCastledNotifications sharedInstance] setLaunchOptionsWithLaunchOptions:launchOptions];
    }
}



@end
