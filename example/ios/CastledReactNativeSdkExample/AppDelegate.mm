#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import "CastledReactBridge.h"
#import <UserNotifications/UserNotifications.h>
#import <React/RCTLinkingManager.h>
#import <React/RCTRootView.h>

//#import <Castled/Castled>

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

  [self registerForPush];
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
  NSLog(@"didReceiveNotificationResponse: %@", self.description);
  [[CastledReactBridge sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];

  completionHandler();
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
  NSLog(@"willPresentNotification: %@", self.description);
  [[CastledReactBridge sharedInstance] userNotificationCenter:center willPresentNotification:notification];
  completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
  NSLog(@"didReceiveRemoteNotification with completionHandler: %@ %@", self.description, userInfo);
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
