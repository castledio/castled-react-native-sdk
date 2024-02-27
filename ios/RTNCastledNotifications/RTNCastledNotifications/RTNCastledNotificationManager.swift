//
//  CastledNotificationManager.swift
//  RTNCastledNotifications
//
//  Created by antony on 26/01/2024.
//

import Castled
import Foundation
import React

@objc public class RTNCastledNotificationManager: NSObject {
    static let shared = RTNCastledNotificationManager()
    private var listeners = [[AnyHashable: Any]]()

    var isReactSdkInitialized: Bool = false {
        didSet {
            if isReactSdkInitialized {
                RTNCastledNotificationManager.shared.triggerListeners()
            }
        }
    }

    override private init() {
        super.init()
    }

    @objc public static func initializeCastledSDK() {
        RTNCastledNotificationManager.enableCastledSwizzling()
    }

    @objc public static func setCastledDelegate() {
        Castled.setDelegate(RTNCastledNotificationManager.shared)
    }

    private static func enableCastledSwizzling() {
        Castled.initializeForCrossPlatform()
    }

    // MARK: - Received notifcation handling

    private func processListeners(item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.listeners.append(item)
            if RTNCastledNotificationManager.shared.isReactSdkInitialized {
                RTNCastledNotificationManager.shared.triggerListeners()
            }
        }
    }

    private func triggerListeners() {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.listeners.forEach { notification in
                if let name = notification[CastledEventNameListenerKey] as? String {
                    RTNCastledNotifications.handleReactObserver(name, notification)
                }
            }
            RTNCastledNotificationManager.shared.listeners.removeAll()
        }
    }
}

// MARK: - Castled Delegates

extension RTNCastledNotificationManager: CastledNotificationDelegate {
    public func notificationClicked(withNotificationType type: CastledNotificationType, buttonAction: CastledButtonAction, userInfo: [AnyHashable: Any]) {
        if type == CastledNotificationType.push {
            if let listenerPayload = CastledNotificationUtils.getPushClickedPayload(buttonAction, userInfo) {
                processListeners(item: listenerPayload)
            }
        }
        else if type == CastledNotificationType.inapp {
            processListeners(item: CastledNotificationUtils.getInappClickedPayload(clickAction: buttonAction))
        }
    }

    public func didReceiveCastledRemoteNotification(withInfo userInfo: [AnyHashable: Any]) {
        if let listenerPayload = CastledNotificationUtils.getPushReceiedPayload(userInfo) {
            processListeners(item: listenerPayload)
        }
    }
}
