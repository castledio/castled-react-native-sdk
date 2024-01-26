//
//  CastledNotificationManager.swift
//  RTNCastledNotifications
//
//  Created by antony on 26/01/2024.
//

import Castled
import Foundation
import React

@objc public class RTNCastledNotificationManager: NSObject, CastledNotificationDelegate {
    static let shared = RTNCastledNotificationManager()
    var clickedNotifications = [[AnyHashable: Any]]()

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
        Castled.setDelegate(RTNCastledNotificationManager.shared)
        RTNCastledNotificationManager.enableCastledSwizzling()
    }

    private static func enableCastledSwizzling() {
        Castled.initializeForCrossPlatform()
    }

    func processClickedItem(item: [AnyHashable: Any]) {
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

    public func notificationClicked(withNotificationType type: CastledNotificationType, action: CastledClickActionType, kvPairs: [AnyHashable: Any]?, userInfo: [AnyHashable: Any]) {
        if type == CastledNotificationType.push {
            processClickedItem(item: userInfo)
        }
    }
}
