//
//  CastledReactBridge.h
//  RTNCastledNotifications
//
//  Created by antony on 02/01/2024.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

@interface CastledReactBridge : NSObject

+ (CastledReactBridge *)sharedInstance;
- (void)setPushToken:(NSString *)token;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;
- (void)didReceiveRemoteNotificationInApplication:(UIApplication *)application withInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
- (void)setNotificationCategoriesWithItems:(NSSet<UNNotificationCategory *> *)items;
- (void)setLaunchOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> * )launchOptions;

@end

NS_ASSUME_NONNULL_END
