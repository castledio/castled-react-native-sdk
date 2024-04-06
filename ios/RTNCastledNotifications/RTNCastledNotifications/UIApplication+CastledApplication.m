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
    });
}

@end
