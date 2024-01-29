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
    var clickedNotifications = [[AnyHashable: Any]]()
    var receivedNotifications = [[AnyHashable: Any]]()

    var isReactSdkInitialized: Bool = false {
        didSet {
            if isReactSdkInitialized {
                RTNCastledNotificationManager.shared.triggerClickedNotifications()
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

    // MARK: - Clicked notifcation handling

    private func processClickedItem(item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.clickedNotifications.append(item)
            if RTNCastledNotificationManager.shared.isReactSdkInitialized {
                RTNCastledNotificationManager.shared.triggerClickedNotifications()
            }
        }
    }

    private func triggerClickedNotifications() {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.clickedNotifications.forEach { notification in
                RTNCastledNotifications.handleNotificationClick(notification)
            }
            RTNCastledNotificationManager.shared.clickedNotifications.removeAll()
        }
    }

    // MARK: - Received notifcation handling

    private func processReceivedItem(item: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.receivedNotifications.append(item)
            if RTNCastledNotificationManager.shared.isReactSdkInitialized {
                RTNCastledNotificationManager.shared.triggerReceivedNotifications()
            }
        }
    }

    private func triggerReceivedNotifications() {
        DispatchQueue.main.async {
            RTNCastledNotificationManager.shared.receivedNotifications.forEach { notification in
                RTNCastledNotifications.handleReceivedNotification(notification)
            }
            RTNCastledNotificationManager.shared.receivedNotifications.removeAll()
        }
    }
}

// MARK: - Castled Delegates

extension RTNCastledNotificationManager: CastledNotificationDelegate {
    public func notificationClicked(withNotificationType type: CastledNotificationType, action: CastledClickActionType, kvPairs: [AnyHashable: Any]?, userInfo: [AnyHashable: Any]) {
        if type == CastledNotificationType.push {
            processClickedItem(item: CastledNotificationUtils.getFinalPushPayloadFrom(type, action: action, kvPairs, userInfo))
        }
    }

    public func didReceiveCastledRemoteNotification(withInfo userInfo: [AnyHashable: Any]) {
        processReceivedItem(item: CastledNotificationUtils.getFinalPushPayloadFrom(.push, action: .none, nil, userInfo))
    }
}
