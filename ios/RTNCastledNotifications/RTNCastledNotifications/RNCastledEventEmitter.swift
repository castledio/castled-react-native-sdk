//
//  RNCastledEventEmitter.swift
//  castled-react-native-sdk
//
//  Created by antony on 12/01/2024.
//

import Foundation
import React

@objc(RNCastledEventEmitter)
class RNCastledEventEmitter: RCTEventEmitter {
    static var shared: RNCastledEventEmitter?

    override init() {
        super.init()
        RNCastledEventEmitter.shared = self
    }

    override func supportedEvents() -> [String] {
        return ["onReceivedNotification", "onNotificationClick"]
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        true
    }

    // Other SDK methods...

    @objc func handleReceivedNotification(_ userInfo: [AnyHashable: Any]) {
        // Handle the received notification in your SDK

        // Notify JavaScript side
        sendEvent(withName: "onReceivedNotification", body: ["userInfo": userInfo])
    }

    @objc func handleNotificationClick(_ userInfo: [AnyHashable: Any]) {
        // Handle the notification click in your SDK

        // Notify JavaScript side
       // sendEvent(withName: "onNotificationClick", body: ["userInfo": userInfo])
    }
}
