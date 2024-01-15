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
public class RTNCastledNotifications: NSObject {
    private static var pushToken = ""
    private static var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private static var notificationCategories: Set<UNNotificationCategory>?

    @objc public static var sharedInstance = RTNCastledNotifications()

    override private init() {
        super.init()
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        true
    }

    // MARK: - REACT BRIDGING

    @objc func initialize(_ configs: NSDictionary) {
        DispatchQueue.main.async {
            let config = CastledConfigs.initialize(appId: (configs["appId"] as? String) ?? "")
            config.enableAppInbox = (configs["enableAppInbox"] as? Bool) ?? false
            config.enableInApp = (configs["enableInApp"] as? Bool) ?? false
            config.enablePush = (configs["enablePush"] as? Bool) ?? false
            config.enableTracking = (configs["enableTracking"] as? Bool) ?? false
            config.permittedBGIdentifier = (configs["permittedBGIdentifier"] as? String) ?? ""
            config.inAppFetchIntervalSec = Int((configs["inAppFetchIntervalSec"] as? String) ?? "") ?? 900
            config.appGroupId = (configs["appgroupId"] as? String) ?? ""
            config.location = CastledLocation.getLocation(from: (configs["location"] as? String) ?? "US")
            config.logLevel = CastledLogLevel.getLogLevel(from: (configs["logLevel"] as? String) ?? "debug")
            Castled.initialize(withConfig: config, andDelegate: nil)
            if let notificationDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
                UNUserNotificationCenter.current().delegate = notificationDelegate
            }
            else {
                print("AppDelegate does not conform to UNUserNotificationCenterDelegate.")
            }
            self.doTheSetupAfterInitialization()
        }
    }

    private func doTheSetupAfterInitialization() {
        if !RTNCastledNotifications.pushToken.isEmpty {
            onTokenFetch(RTNCastledNotifications.pushToken)
        }
        if let categories = RTNCastledNotifications.notificationCategories {
            setNotificationCategories(withItems: categories)
        }
        if let launcOptions = RTNCastledNotifications.launchOptions {
            setLaunchOptions(launchOptions: launcOptions)
        }
        Castled.sharedInstance.appBecomeActive()
    }

    @objc func setUserId(_ userId: String, userToken: String?) {
        Castled.sharedInstance.setUserId(userId, userToken: userToken)
    }

    @objc func logCustomAppEvent(_ eventName: String, eventParams: NSDictionary?) {
        Castled.sharedInstance.logCustomAppEvent(eventName: eventName, params: eventParams as? [String: Any] ?? [:])
    }

    @objc func setUserAttributes(_ attributes: NSDictionary) {
        Castled.sharedInstance.setUserAttributes(params: attributes as? [String: Any] ?? [:])
    }

    @objc func logout() {
        //  Castled.sharedInstance.logout()
    }

    // MARK: - PUSH METHODS

    @objc public func onTokenFetch(_ token: String) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.setPushToken(token)
            RTNCastledNotifications.pushToken = ""
        }
        else {
            RTNCastledNotifications.pushToken = token
        }
    }

    @objc public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.userNotificationCenter(center, didReceive: response)
        }
    }

    @objc public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.userNotificationCenter(center, willPresent: notification)
            //  RNCastledEventEmitter.shared?.handleReceivedNotification(notification.request.content.userInfo)
        }
    }

    @objc public func didReceiveRemoteNotification(inApplication application: UIApplication, withInfo userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.didReceiveRemoteNotification(inApplication: application, withInfo: userInfo, fetchCompletionHandler: { data in
                completionHandler(data)

            })
        }
        else {
            completionHandler(.newData)
        }
    }

    @objc public func setLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.setLaunchOptions(launchOptions)
            RTNCastledNotifications.launchOptions = nil
        }
        else {
            RTNCastledNotifications.launchOptions = launchOptions
        }
    }

    @objc public func setNotificationCategories(withItems items: Set<UNNotificationCategory>) {
        if Castled.sharedInstance.isCastledInitialized() {
            Castled.sharedInstance.setNotificationCategories(withItems: items)
            RTNCastledNotifications.notificationCategories = nil
        }
        else {
            RTNCastledNotifications.notificationCategories = items
        }
    }
}
