//
//  CastledModule.swift
//  CastledBridge
//
//  Created by antony on 18/12/2023.
//
import Foundation
import React
@_spi(CastledInternal) import Castled

@objc(RTNCastledNotifications)
public class RTNCastledNotifications: RCTEventEmitter {
    private static var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private static var notificationCategories: Set<UNNotificationCategory>?
    private var swizzzlingDisabled = Bundle.main.object(forInfoDictionaryKey: "CastledSwizzlingDisabled") as? Bool ?? false

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

            RTNCastledNotifications.doTheSetupAfterInitialization()
            self.setTheNotificiationDelegate()
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
            if self.swizzzlingDisabled {
                if let appDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
                    UNUserNotificationCenter.current().delegate = appDelegate
                    self.requestAPNSPermission { success in
                        resolve(success)
                    }
                }
                else {
                    let error = NSError(domain: "Castled", code: -1, userInfo: [NSLocalizedDescriptionKey: "AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol(Native setup > iOS > Step 5: AppDelegate Swizzling in Castled SDK) https://docs.castled.io/developer-resources/sdk-integration/reactnative/push-notifications#native-setup"])
                    reject("\(error.code)", error.localizedDescription, error)
                }
            }
            else {
                self.requestAPNSPermission { success in
                    resolve(success)
                }
            }
        }
    }

    private func requestAPNSPermission(completion: @escaping (_ success: Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { granted, _ in
            completion(granted)
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }

    @objc func getPushPermission(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            resolve(settings.authorizationStatus == .authorized)
        }
    }

    private static func doTheSetupAfterInitialization() {
        if let categories = RTNCastledNotifications.notificationCategories {
            RTNCastledNotifications.setNotificationCategories(withItems: categories)
        }
        if let launcOptions = RTNCastledNotifications.launchOptions {
            RTNCastledNotifications.setLaunchOptions(launchOptions: launcOptions)
        }
        CastledLifeCycleManager.sharedInstance.appDidBecomeActive()
        RTNCastledNotificationManager.shared.isReactSdkInitialized = true
    }

    private func setTheNotificiationDelegate() {
        if swizzzlingDisabled {
            // enabled case is handled by the Castled iOS SDK, This is to prevent other push SDKs from overriding the push delegate to their own class
            if let notificationDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
                UNUserNotificationCenter.current().delegate = notificationDelegate
            }
            else {
                Castled.sharedInstance.logMessage("AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol(Native setup > iOS > Step 5: AppDelegate Swizzling in Castled SDK) https://docs.castled.io/developer-resources/sdk-integration/reactnative/push-notifications#native-setup", .error)
            }
        }
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

    @objc public static func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        Castled.sharedInstance.didReceiveRemoteNotification(userInfo)
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

    @objc func logPageViewedEvent() {
        DispatchQueue.main.async {
            guard let vc = RCTPresentedViewController() else {
                return
            }
            Castled.sharedInstance.logPageViewedEvent(vc)
        }
    }
}

extension String {
    func getViewController() -> UIViewController? {
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            print("CFBundleName - \(appName)")
            if let viewControllerType = NSClassFromString("\(appName).\(self)") as? UIViewController.Type {
                return viewControllerType.init()
            }
        }

        return nil
    }
}
