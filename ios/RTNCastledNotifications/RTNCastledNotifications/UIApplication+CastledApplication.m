//
//  UIApplication+CastledApplication.m
//  RTNCastledNotifications
//
//  Created by antony on 24/01/2024.
//

#import "UIApplication+CastledApplication.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#ifdef __has_include
    #if __has_include(<castled_react_native_sdk/castled_react_native_sdk-Swift.h>)
        #import <castled_react_native_sdk/castled_react_native_sdk-Swift.h>
    #else
        #import "castled_react_native_sdk-Swift.h"
    #endif
#else
    #import "castled_react_native_sdk-Swift.h"
#endif

@implementation UIApplication (CastledApplication)

//gets called by the ObjC runtime early in the app lifecycle
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [RTNCastledNotificationManager setCastledDelegate];
        if ([self shouldPerformSwizzling]) {
            // Swizzle the setDelegate method with setSwizzledDelegate
            method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(setSwizzledDelegate:)));
        }
    });
}


// Custom setter for the swizzled delegate
- (void) setSwizzledDelegate:(id<UIApplicationDelegate>)delegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class delegateClass = [delegate class];
        // Swizzle the application:didFinishLaunchingWithOptions: method
        swizzleMethod(self.class, @selector(swizzledApplication:didFinishLaunchingWithOptions:),
                       delegateClass, @selector(application:didFinishLaunchingWithOptions:));
        // Call the original setter with the provided delegate
        [self setSwizzledDelegate:delegate];
    });
}

// Check the value of a specified key in the app's Info.plist
+ (BOOL)shouldPerformSwizzling {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSNumber *swizzlingDisabled = infoDict[@"CastledSwizzlingDisabled"];
    // Perform swizzling only if the key is present and has a true value
    return !(swizzlingDisabled != nil &&  [swizzlingDisabled boolValue]);
}

// Custom implementation of the swizzled application:didFinishLaunchingWithOptions: method
- (BOOL)swizzledApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    if ([self respondsToSelector:@selector(swizzledApplication:didFinishLaunchingWithOptions:)]){
        [RTNCastledNotificationManager initializeCastledSDK];
        id<UIApplicationDelegate, UNUserNotificationCenterDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        // Check if the delegate conforms to the UNUserNotificationCenterDelegate protocol
        if ([appDelegate conformsToProtocol:@protocol(UNUserNotificationCenterDelegate)]) {
            // Set the delegate for UNUserNotificationCenter
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:appDelegate];
        } else {
            NSLog(@"AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol(Native setup > iOS > Step 2) https://docs.castled.io/developer-resources/sdk-integration/reactnative/push-notifications#native-setup");
        }
        return [self swizzledApplication:application didFinishLaunchingWithOptions:launchOptions];
    }
    // Default behavior if the original method is not implemented
    return YES;
}

// Swizzle the implementation of a method from one class to another
static void swizzleMethod(Class sourceClass, SEL sourceSelector, Class destinationClass, SEL destinationSelector) {
    // Get the method and its implementation from the source class
    Method sourceMethod = class_getInstanceMethod(sourceClass, sourceSelector);
    IMP implementation = method_getImplementation(sourceMethod);
    const char* methodTypeEncoding = method_getTypeEncoding(sourceMethod);

    // Try to add the method to the destination class
    BOOL isAdded = class_addMethod(destinationClass, destinationSelector, implementation, methodTypeEncoding);

    // If the method already exists, exchange the implementations
    if (!isAdded) {
        class_addMethod(destinationClass, sourceSelector, implementation, methodTypeEncoding);
        sourceMethod = class_getInstanceMethod(destinationClass, sourceSelector);
        Method destinationMethod = class_getInstanceMethod(destinationClass, destinationSelector);
        method_exchangeImplementations(destinationMethod, sourceMethod);
    }
}
@end
