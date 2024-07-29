//
//  CastledReactBridge.h
//  RTNCastledNotifications
//
//  Created by antony on 02/01/2024.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "CastledReactPushConstants.h"
NS_ASSUME_NONNULL_BEGIN

@interface CastledReactBridge : NSObject

+ (CastledReactBridge *)sharedInstance;
- (void)setPushToken:(NSString *)token type:(CastledTokenType)type;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)setNotificationCategoriesWithItems:(NSSet<UNNotificationCategory *> *)items;
- (void)setLaunchOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> * )launchOptions;

@end

NS_ASSUME_NONNULL_END
