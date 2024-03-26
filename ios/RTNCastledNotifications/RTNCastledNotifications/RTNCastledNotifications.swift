//
//  CastledModule.swift
//  CastledBridge
//
//  Created by antony on 18/12/2023.
//
import Castled
import Foundation
import React

@objc(RTNCastledNotifications)
public class RTNCastledNotifications: RCTEventEmitter {
    private static var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private static var notificationCategories: Set<UNNotificationCategory>?

    override private init() {
        super.init()
    }

    // MARK: - REACT BRIDGING

    @objc func initialize(_ configs: NSDictionary) {
        DispatchQueue.main.async {
            let config = CastledConfigs.initialize(appId: (configs["appId"] as? String) ?? "")
            config.enableAppInbox = (configs["enableAppInbox"] as? Bool) ?? false
            config.enableInApp = (configs["enableInApp"] as? Bool) ?? false
            config.enablePush = (configs["enablePush"] as? Bool) ?? false
            config.enableTracking = (configs["enableTracking"] as? Bool) ?? false
            config.enableSessionTracking = (configs["enableSessionTracking"] as? Bool) ?? true
            config.skipUrlHandling = (configs["skipUrlHandling"] as? Bool) ?? false
            config.inAppFetchIntervalSec = Int((configs["inAppFetchIntervalSec"] as? String) ?? "900") ?? 900
            config.sessionTimeOutSec = (configs["sessionTimeOutSec"] as? Int) ?? 900
            config.appGroupId = (configs["appgroupId"] as? String) ?? ""
            config.location = CastledLocation.getLocation(from: (configs["location"] as? String) ?? "US")
            config.logLevel = CastledLogLevel.getLogLevel(from: (configs["logLevel"] as? String) ?? "debug")
            Castled.initialize(withConfig: config, andDelegate: nil)
            if let notificationDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
                UNUserNotificationCenter.current().delegate = notificationDelegate
            }
            else {
                Castled.sharedInstance.logMessage("AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol(Native setup > iOS > Step 2) https://docs.castled.io/developer-resources/sdk-integration/reactnative/push-notifications#native-setup", .error)
            }
            RTNCastledNotifications.doTheSetupAfterInitialization()
        }
    }

    @objc func setUserId(_ userId: String, userToken: String?) {
        DispatchQueue.main.async {
            Castled.sharedInstance.setUserId(userId, userToken: userToken)
        }
    }

    @objc func logCustomAppEvent(_ eventName: String, eventParams: NSDictionary?) {
        DispatchQueue.main.async {
            Castled.sharedInstance.logCustomAppEvent(eventName, params: eventParams as? [String: Any] ?? [:])
        }
    }

    @objc func setUserAttributes(_ attributes: NSDictionary) {
        DispatchQueue.main.async {
            let castleduserattributes = CastledUserAttributes()
            if let attributesDict = attributes as? [String: Any] {
                castleduserattributes.setAttributes(attributesDict)
            }
            else {
                attributes.enumerateKeysAndObjects { key, value, _ in
                    castleduserattributes.setCustomAttribute("\(key)", value)
                }
            }
            Castled.sharedInstance.setUserAttributes(castleduserattributes)
        }
    }

    @objc func logout() {
        Castled.sharedInstance.logout()
    }

    @objc func requestPushPermission(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
                UNUserNotificationCenter.current().delegate = appDelegate
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { granted, _ in
                    resolve(granted)
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                })
            }
            else {
                resolve(false)
                Castled.sharedInstance.logMessage("AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol. https://docs.castled.io/developer-resources/sdk-integration/ios/push-notifications#registering-push-notification", .error)
            }
        }
    }

    private static func doTheSetupAfterInitialization() {
        if let categories = RTNCastledNotifications.notificationCategories {
            RTNCastledNotifications.setNotificationCategories(withItems: categories)
        }
        if let launcOptions = RTNCastledNotifications.launchOptions {
            RTNCastledNotifications.setLaunchOptions(launchOptions: launcOptions)
        }
        Castled.sharedInstance.appBecomeActive()
        RTNCastledNotificationManager.shared.isReactSdkInitialized = true
    }

    // MARK: - PUSH METHODS

    @objc public static func onTokenFetch(_ token: String) {
        Castled.sharedInstance.setPushToken(token)
    }

    @objc public static func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) {
        Castled.sharedInstance.userNotificationCenter(center, didReceive: response)
//        RTNCastledNotificationManager.shared.processClickedItem(item: response.notification.request.content.userInfo)
    }

    @objc public static func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) {
        Castled.sharedInstance.userNotificationCenter(center, willPresent: notification)
    }

    @objc public static func didReceiveRemoteNotification(inApplication application: UIApplication, withInfo userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Castled.sharedInstance.didReceiveRemoteNotification(inApplication: application, withInfo: userInfo, fetchCompletionHandler: { data in
            completionHandler(data)

        })
    }

    @objc public static func setLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.setLaunchOptions(launchOptions)
            RTNCastledNotifications.launchOptions = nil
        }
        else {
            RTNCastledNotifications.launchOptions = launchOptions
        }
    }

    @objc public static func setNotificationCategories(withItems items: Set<UNNotificationCategory>) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.setNotificationCategories(withItems: items)
            RTNCastledNotifications.notificationCategories = nil
        }
        else {
            RTNCastledNotifications.notificationCategories = items
        }
    }
}
