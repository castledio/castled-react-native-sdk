//
//  RTNCastledEventEmitter.swift
//  castled-react-native-sdk
//
//  Created by antony on 12/01/2024.
//

import Foundation
import React

public extension RTNCastledNotifications {
    @objc override func supportedEvents() -> [String] {
        let listenersArray = CastledListeners.allCases.map { $0.rawValue }

        return listenersArray
    }

    @objc override func startObserving() {}

    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    // MARK: - SDK methods...

    @objc internal func handleReceivedNotification(_ userInfo: [AnyHashable: Any]) {
        // Notify JavaScript side
        sendEvent(withName: CastledListeners.CastledListenerPushReceived.rawValue, body: userInfo)
    }

    @objc internal func handleNotificationClick(_ userInfo: [AnyHashable: Any]) {
        // Notify JavaScript side
        sendEvent(withName: CastledListeners.CastledListenerPushClicked.rawValue, body: userInfo)
    }
}
