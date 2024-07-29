//
//  CastledNotificationManager.swift
//  RTNCastledNotifications
//
//  Created by antony on 26/01/2024.
//

import Castled
import Foundation
import React
@_spi(CastledInternal) import Castled

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

    @objc public static func initializeComponents() {
        CastledShared.sharedInstance.initializeComponents()
        CastledShared.sharedInstance.setDelegate(RTNCastledNotificationManager.shared)
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

    func triggerListeners() {
        guard RTNCastledNotifications.isObserverInitiated, isReactSdkInitialized else { return }
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
        switch type {
        case CastledNotificationType.push:
            if let listenerPayload = CastledNotificationUtils.getPushClickedPayload(buttonAction, userInfo) {
                processListeners(item: listenerPayload)
            }
        case CastledNotificationType.inapp:
            processListeners(item: CastledNotificationUtils.getInappClickedPayload(clickAction: buttonAction))

        case CastledNotificationType.inbox:
            processListeners(item: CastledNotificationUtils.getInboxClickedPayload(clickAction: buttonAction))

        default:
            break
        }
    }

    public func didReceiveCastledRemoteNotification(withInfo userInfo: [AnyHashable: Any]) {
        if let listenerPayload = CastledNotificationUtils.getPushReceiedPayload(userInfo) {
            processListeners(item: listenerPayload)
        }
    }
}
