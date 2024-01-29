//
//  CastledNotificationUtils.swift
//  RTNCastledNotifications
//
//  Created by antony on 29/01/2024.
//

import Castled
import Foundation

enum CastledNotificationUtils {
    static func getFinalPushPayloadFrom(_ type: CastledNotificationType, action: CastledClickActionType, _ clickAction: [AnyHashable: Any]?, _ notificaion: [AnyHashable: Any]) -> [AnyHashable: Any] {
        var payload = [AnyHashable: Any]()
        payload["notification"] = notificaion.getNotificationObject()
        if let clickEvent = clickAction {
            payload["clickAction"] = clickEvent.getNotificationClickObject(action)
        }
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
                Castled.sharedInstance.logMessage(error.localizedDescription, CastledLogLevel.error)
            }
        }
        return nil
    }
}
