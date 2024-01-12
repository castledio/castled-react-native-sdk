//
//  AppdelgateT.swift
//  CastledReactNativeSdkExample
//
//  Created by antony on 12/01/2024.
//

import Foundation

class AppDelegateC: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
}

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  CastledReactBridge.sharedInstance().setLaunchOptions(launchOptions)
  return true
}

extension AppDelegateC: UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    CastledReactBridge.sharedInstance().setPushToken(deviceTokenString)
    print("APNs token \(deviceTokenString) \(self.description)")
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications \(error.localizedDescription)")
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Handle the click events
    CastledReactBridge.sharedInstance().userNotificationCenter(center, didReceive: response)
    completionHandler()
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    CastledReactBridge.sharedInstance().userNotificationCenter(center, willPresent: notification)
    completionHandler([.alert, .badge, .sound])
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    CastledReactBridge.sharedInstance().didReceiveRemoteNotification(in: application, withInfo: userInfo, fetchCompletionHandler: { _ in
      completionHandler(.newData)

    })
  }
}
