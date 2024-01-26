//
//  RTNCastledEventEmitter.swift
//  castled-react-native-sdk
//
//  Created by antony on 12/01/2024.
//

import Foundation
import React

public extension RTNCastledNotifications {
    static var isObserverInitiated = false
    @objc override func supportedEvents() -> [String] {
        let listenersArray = CastledListeners.allCases.map { $0.rawValue }

        return listenersArray
    }

    @objc override func startObserving() {
        RTNCastledNotifications.isObserverInitiated = true
        for eventName in supportedEvents() {
            NotificationCenter.default.addObserver(self, selector: #selector(handleEventNotification(_:)), name: NSNotification.Name(eventName), object: nil)
        }
    }

    @objc override func stopObserving() {
        RTNCastledNotifications.isObserverInitiated = false
        for eventName in supportedEvents() {
            NotificationCenter.default.removeObserver(NSNotification.Name(eventName))
        }
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    // MARK: - SDK methods...

    @objc func handleEventNotification(_ notification: Notification) {
        guard RTNCastledNotifications.isObserverInitiated else { return }
        if let notificationName = notification.name.rawValue as? String {
            sendEvent(withName: notificationName, body: notification.userInfo)
        }
    }

    @objc internal static func handleReceivedNotification(_ userInfo: [AnyHashable: Any]) {
        // Notify JavaScript side
        NotificationCenter.default.post(name: NSNotification.Name(CastledListeners.CastledListenerPushReceived.rawValue), object: nil, userInfo: userInfo)
    }

    @objc internal static func handleNotificationClick(_ userInfo: [AnyHashable: Any]) {
        // Notify JavaScript side
        NotificationCenter.default.post(name: NSNotification.Name(CastledListeners.CastledListenerPushClicked.rawValue), object: nil, userInfo: userInfo)
    }
}
