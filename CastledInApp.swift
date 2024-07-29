//
//  CastledInApp.swift
//  castled-react-native-sdk
//
//  Created by antony on 29/07/2024.
//

import Castled
import CastledInbox
import Foundation
import UIKit

extension RTNCastledNotifications {
    @objc func pauseInApp() {
        Castled.sharedInstance.pauseInApp()
    }

    @objc func resumeInApp() {
        Castled.sharedInstance.resumeInApp()
    }

    @objc func stopInApp() {
        Castled.sharedInstance.stopInApp()
    }
}
