//
//  CastledNotificationUtils.swift
//  RTNCastledNotifications
//
//  Created by antony on 29/01/2024.
//

import Castled
import Foundation

let CastledNotificationListenerKey = "notification"
let CastledClickActionListenerKey = "clickAction"
let CastledEventNameListenerKey = "castledEventListenerName"

enum CastledNotificationUtils {
    static func getPushClickedPayload(_ clickAction: CastledButtonAction?, _ notificaion: [AnyHashable: Any]) -> [AnyHashable: Any]? {
        guard notificaion[CastledReactConstants.castled] != nil else {
            return nil
        }

        var payload = [AnyHashable: Any]()
        payload[CastledNotificationListenerKey] = notificaion.toNotificationDictionary()
        if let clickEvent = clickAction {
            payload[CastledClickActionListenerKey] = clickEvent.toDictionary()
        }
        payload[CastledEventNameListenerKey] = CastledReactConstants.CastledListeners.CastledListenerPushClicked.rawValue
        return payload
    }

    static func getPushReceiedPayload(_ notificaion: [AnyHashable: Any]) -> [AnyHashable: Any]? {
        var payload = [AnyHashable: Any]()
        guard notificaion[CastledReactConstants.castled] != nil else {
            return nil
        }
        payload.merge(notificaion.toNotificationDictionary()) { _, new in new }
        payload[CastledEventNameListenerKey] = CastledReactConstants.CastledListeners.CastledListenerPushReceived.rawValue
        return payload
    }

    static func getInappClickedPayload(clickAction: CastledButtonAction) -> [AnyHashable: Any] {
        var payload = [AnyHashable: Any]()
        payload.merge(clickAction.toDictionary()) { _, new in new }
        payload[CastledEventNameListenerKey] = CastledReactConstants.CastledListeners.CastledListenerInAppMessageClicked.rawValue
        return payload
    }

    static func getInboxClickedPayload(clickAction: CastledButtonAction) -> [AnyHashable: Any] {
        var payload = [AnyHashable: Any]()
        payload.merge(clickAction.toDictionary()) { _, new in new }
        payload[CastledEventNameListenerKey] = CastledReactConstants.CastledListeners.CastledListenerInboxNotificationClicked.rawValue
        return payload
    }

    static func convertToArray(text: String) -> Any? {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                // Castled.sharedInstance.logMessage(error.localizedDescription, CastledLogLevel.error)
            }
        }
        return nil
    }
}
