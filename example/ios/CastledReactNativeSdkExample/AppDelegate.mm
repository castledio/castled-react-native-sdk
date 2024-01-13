#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import "CastledReactBridge.h"
#import <UserNotifications/UserNotifications.h>
#import <React/RCTLinkingManager.h>
#import <React/RCTRootView.h>

//#import <Castled/Castled>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate>
{

}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  self.moduleName = @"TestApp";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.

  self.initialProps = @{};

//  [self registerForPush];
  [[CastledReactBridge sharedInstance] setNotificationCategoriesWithItems:[self getNotificationCategories]];
  [[CastledReactBridge sharedInstance] setLaunchOptions:launchOptions];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

#pragma mark - Push Notifications (manual integration)


#pragma mark - UNUserNotificationCenter Delegate Methods

- (void)registerForPush {

  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  center.delegate = (id)self;
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
    if( !error ){
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
      });
    }
  }];
}

- (NSSet<UNNotificationCategory *> *)getNotificationCategories {
  // Create the custom actions
  UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"ACCEPT" title:@"Accept" options:UNNotificationActionOptionForeground];
  UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"DECLINE" title:@"Decline" options:0];

  // Create the category with the custom actions
  UNNotificationCategory *customCategory1 = [UNNotificationCategory categoryWithIdentifier:@"ACCEPT_DECLINE" actions:@[action1, action2] intentIdentifiers:@[] options:0];

  UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"YES" title:@"Yes" options:UNNotificationActionOptionForeground];
  UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"NO" title:@"No" options:0];

  // Create the category with the custom actions
  UNNotificationCategory *customCategory2 = [UNNotificationCategory categoryWithIdentifier:@"YES_NO" actions:@[action3, action4] intentIdentifiers:@[] options:0];

  NSSet<UNNotificationCategory *> *categoriesSet = [NSSet setWithObjects:customCategory1, customCategory2, nil];

  return categoriesSet;
}
/*************************************************************IMPPORTANT*************************************************************/
//If you disabled the swizzling in plist you should call the required functions in the delegate methods

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

  NSMutableString *deviceTokenString =[NSMutableString string];
  if (@available(iOS 13.0, *)) {
        deviceTokenString = [NSMutableString string];
        const unsigned char *bytes = (const unsigned char *)[deviceToken bytes];
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
    } else {
        NSString *deviceToken1 =  [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
          deviceTokenString = [[NSMutableString alloc] initWithString:deviceToken1];
    }

  NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceTokenString);
  [[CastledReactBridge sharedInstance] setPushToken:deviceTokenString];
}
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  NSLog(@"failed to register for remote notifications: %@ %@", self.description, error.localizedDescription);
}
-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
  [[CastledReactBridge sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
  completionHandler();
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
  [[CastledReactBridge sharedInstance] userNotificationCenter:center willPresentNotification:notification];
  completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
  [[CastledReactBridge sharedInstance] didReceiveRemoteNotificationInApplication:application withInfo:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult) {
    completionHandler(UIBackgroundFetchResultNewData);

  }];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  return [RCTLinkingManager application:application openURL:url options:options];
}

@end
