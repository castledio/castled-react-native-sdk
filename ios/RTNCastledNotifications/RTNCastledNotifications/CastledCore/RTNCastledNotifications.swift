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
  private var swizzlingDisabled = Bundle.main.object(forInfoDictionaryKey: CastledConstants.kCastledSwzzlingDisableKey) as? Bool ?? false
  private static var isInited = false
  override private init() {
    super.init()
  }

  // MARK: - REACT BRIDGING

  @objc func initialize(_ configs: NSDictionary) {
    if RTNCastledNotifications.isInited {
      return
    }
    RTNCastledNotifications.isInited = true
    DispatchQueue.main.async {
      Castled.initialize(withConfig: configs.toCastledConfig(), andDelegate: nil)
      RTNCastledNotifications.doTheSetupAfterInitialization()
      self.setTheNotificationDelegate()
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
      if self.swizzlingDisabled {
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
      Castled.sharedInstance.requestPushPermission(showSettingsAlert: true)
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

  private func setTheNotificationDelegate() {
    if swizzlingDisabled {
      // enabled case is handled by the Castled iOS SDK, This is to prevent other push SDKs from overriding the push delegate to their own class
      if let notificationDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate {
        UNUserNotificationCenter.current().delegate = notificationDelegate
      }
      else {
        CastledShared.sharedInstance.logMessage("AppDelegate does not conform to UNUserNotificationCenterDelegate. Please confirm to UIApplicationDelegate protocol(Native setup > iOS > Step 5: AppDelegate Swizzling in Castled SDK) https://docs.castled.io/developer-resources/sdk-integration/reactnative/push-notifications#native-setup", .error)
      }
    }
  }

  // MARK: - PUSH METHODS

  @objc public static func onTokenFetch(_ token: String, _ pushTokenType: String) {
    let tokenType: CastledPushTokenType = pushTokenType == "FCM" ? .fcm : .apns
    Castled.sharedInstance.setPushToken(token, type: tokenType)
  }

  @objc public static func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) {
    Castled.sharedInstance.userNotificationCenter(center, didReceive: response)
  }

  @objc public static func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) {
    Castled.sharedInstance.userNotificationCenter(center, willPresent: notification)
  }

  @objc public static func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
    Castled.sharedInstance.didReceiveRemoteNotification(userInfo)
  }

  @objc public static func setLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]) {
    if CastledShared.sharedInstance.isCastledInitialized() {
      Castled.sharedInstance.setLaunchOptions(launchOptions)
      RTNCastledNotifications.launchOptions = nil
    }
    else {
      RTNCastledNotifications.launchOptions = launchOptions
    }
  }

  @objc public static func setNotificationCategories(withItems items: Set<UNNotificationCategory>) {
    if CastledShared.sharedInstance.isCastledInitialized() {
      Castled.sharedInstance.setNotificationCategories(withItems: items)
      RTNCastledNotifications.notificationCategories = nil
    }
    else {
      RTNCastledNotifications.notificationCategories = items
    }
  }

  @objc func logPageViewedEvent(_ screenName: String) {
    Castled.sharedInstance.logPageViewedEvent(screenName)
  }
}
