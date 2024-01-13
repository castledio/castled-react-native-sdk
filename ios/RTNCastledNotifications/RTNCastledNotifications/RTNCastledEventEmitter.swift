//
//  RTNCastledEventEmitter.swift
//  castled-react-native-sdk
//
//  Created by antony on 12/01/2024.
//

import Foundation
import React

@objc(RTNCastledEventEmitter)
class RTNCastledEventEmitter: RCTEventEmitter {
    static var shared: RTNCastledEventEmitter?

    override init() {
        super.init()
        RTNCastledEventEmitter.shared = self
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
