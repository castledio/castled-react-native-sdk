//
//  CastledNotification+Extensions.swift
//  RTNCastledNotifications
//
//  Created by antony on 29/01/2024.
//

import Castled
import Foundation

extension [AnyHashable: Any] {
    func toNotificationDictionary() -> [String: Any] {
        var notification = [String: Any]()
        notification["notificationId"] = ""
        notification["body"] = ""
        notification["badge"] = "0"
        if let aps = self["aps"] as? [AnyHashable: Any] {
            notification["category"] = aps["category"] as? String ?? ""
            notification["threadId"] = aps["thread-id"] as? String ?? ""
            notification["contentAvailable"] = aps["content-available"] as? String ?? "0"
            notification["interruptionLevel"] = aps["interruption-level"] as? String ?? ""
            notification["relevanceScore"] = Float("\(String(describing: aps["relevance-score"] ?? "0.0"))")
            notification["mutableContent"] = String(describing: aps["mutable-content"] ?? "0") == "1" ? true : false
            notification["badge"] = "\(String(describing: aps["badge"] ?? "0"))"
            notification["sound"] = aps["sound"] as? String ?? "default"
            if let alert = aps["alert"] as? [AnyHashable: Any] {
                notification["title"] = alert["title"] as? String ?? ""
                notification["subtitle"] = alert["subtitle"] as? String ?? ""
                notification["body"] = alert["body"] as? String ?? ""
            }
        }
        if let castled = self["castled"] as? [AnyHashable: Any] {
            if let category_actions = castled["category_actions"] as? String, let actionButtons = CastledNotificationUtils.convertToDictionary(text: category_actions), let actionComponents = actionButtons["actionComponents"] as? [[String: Any]] {
                notification["actionButtons"] = actionComponents.toArray()
            }
            if let castled_notification_id = castled["castled_notification_id"] as? String {
                notification["notificationId"] = castled_notification_id
            }
            /* if let msgFramesString = castled["msg_frames"] as? String, let detailsArray = CastledNotificationUtils.convertToArray(text: msgFramesString) as? [Any] {
                 notification["attachments"] = detailsArray
             }*/
        }
        notification["shouldIncrementBadge"] = notification["badge"] as! String == "1" ? true : false
        return notification
    }

    func toClickedDictionary() -> [String: Any] {
        var clickAction = [String: Any]()
        clickAction["clickActionUri"] = self["clickActionUrl"] as? String ?? self["url"] as? String ?? ""
        clickAction["keyVals"] = self["keyVals"] ?? [:]
        clickAction["buttonTitle"] = self["buttonTitle"] ?? self["actionId"] ?? ""
        clickAction["actionType"] = self["clickAction"] ?? "DEFAULT"
        return clickAction
    }
}

extension CastledButtonAction {
    func toDictionary() -> [String: Any] {
        var clickAction = [String: Any]()
        clickAction["clickActionUri"] = self.actionUri ?? ""
        clickAction["keyVals"] = self.keyVals ?? [:]
        clickAction["buttonTitle"] = self.buttonTitle ?? ""
        clickAction["actionType"] = self.actionType.stringValue
        return clickAction
    }
}

extension [[String: Any]] {
    func toArray() -> Array {
        var buttons = [[String: Any]]()
        forEach { button in
            let anyHashableDictionary: [AnyHashable: Any] = button.mapValues { $0 }
            buttons.append(anyHashableDictionary.toClickedDictionary())
        }
        return buttons
    }
}
