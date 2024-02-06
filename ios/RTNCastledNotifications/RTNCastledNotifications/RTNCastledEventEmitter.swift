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
        if let notificationName = notification.name.rawValue as? String,var info = notification.userInfo {
            info.removeValue(forKey: CastledEventNameListenerKey)
            sendEvent(withName: notificationName, body: info)
        }
    }

    @objc internal static func handleReactObserver(_ name: String,_ userInfo: [AnyHashable: Any]) {
        // Notify JavaScript side
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: userInfo)
    }
    
}
