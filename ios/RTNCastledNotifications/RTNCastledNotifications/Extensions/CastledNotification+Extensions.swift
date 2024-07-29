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
        notification[CastledReactConstants.PushNotification.notificationId] = ""
        notification[CastledReactConstants.PushNotification.body] = ""
        notification[CastledReactConstants.PushNotification.badge] = "0"
        if let aps = self[CastledReactConstants.PushNotification.aps] as? [AnyHashable: Any] {
            notification[CastledReactConstants.PushNotification.category] = aps[CastledReactConstants.PushNotification.category] as? String ?? ""
            notification[CastledReactConstants.PushNotification.threadId] = aps["thread-id"] as? String ?? ""
            notification[CastledReactConstants.PushNotification.contentAvailable] = aps["content-available"] as? String ?? "0"
            notification[CastledReactConstants.PushNotification.interruptionLevel] = aps["interruption-level"] as? String ?? ""
            notification[CastledReactConstants.PushNotification.relevanceScore] = Float("\(String(describing: aps["relevance-score"] ?? "0.0"))")
            notification[CastledReactConstants.PushNotification.mutableContent] = String(describing: aps["mutable-content"] ?? "0") == "1" ? true : false
            notification[CastledReactConstants.PushNotification.badge] = "\(String(describing: aps[CastledReactConstants.PushNotification.badge] ?? "0"))"
            notification[CastledReactConstants.PushNotification.sound] = aps[CastledReactConstants.PushNotification.sound] as? String ?? "default"
            if let alert = aps[CastledReactConstants.PushNotification.alert] as? [AnyHashable: Any] {
                notification[CastledReactConstants.PushNotification.title] = alert[CastledReactConstants.PushNotification.title] as? String ?? ""
                notification[CastledReactConstants.PushNotification.subtitle] = alert[CastledReactConstants.PushNotification.subtitle] as? String ?? ""
                notification[CastledReactConstants.PushNotification.body] = alert[CastledReactConstants.PushNotification.body] as? String ?? ""
            }
        }
        if let castled = self[CastledReactConstants.castled] as? [AnyHashable: Any] {
            if let category_actions = castled[CastledReactConstants.PushNotification.categoryActions] as? String, let actionButtons = CastledNotificationUtils.convertToDictionary(text: category_actions), let actionComponents = actionButtons[CastledReactConstants.PushNotification.actionComponents] as? [[String: Any]] {
                notification[CastledReactConstants.PushNotification.actionButtons] = actionComponents.toArray()
            }
            if let castled_notification_id = castled[CastledReactConstants.PushNotification.castledNotificationId] as? String {
                notification[CastledReactConstants.PushNotification.notificationId] = castled_notification_id
            }
            /* if let msgFramesString = castled["msg_frames"] as? String, let detailsArray = CastledNotificationUtils.convertToArray(text: msgFramesString) as? [Any] {
                 notification["attachments"] = detailsArray
             }*/
        }
        notification[CastledReactConstants.PushNotification.shouldIncrementBadge] = notification[CastledReactConstants.PushNotification.badge] as! String == "1" ? true : false
        return notification
    }

    func toClickedDictionary() -> [String: Any] {
        var clickAction = [String: Any]()
        clickAction[CastledReactConstants.PushNotification.ClickAction.clickActionUri] = self["clickActionUrl"] as? String ?? self["url"] as? String ?? ""
        clickAction[CastledReactConstants.PushNotification.ClickAction.keyVals] = self["keyVals"] ?? [:]
        clickAction[CastledReactConstants.PushNotification.ClickAction.buttonTitle] = self["buttonTitle"] ?? self["actionId"] ?? ""
        clickAction[CastledReactConstants.PushNotification.ClickAction.actionType] = self["clickAction"] ?? "DEFAULT"
        return clickAction
    }
}

extension CastledButtonAction {
    func toDictionary() -> [String: Any] {
        var clickAction = [String: Any]()
        clickAction[CastledReactConstants.PushNotification.ClickAction.clickActionUri] = self.actionUri ?? ""
        clickAction[CastledReactConstants.PushNotification.ClickAction.keyVals] = self.keyVals ?? [:]
        clickAction[CastledReactConstants.PushNotification.ClickAction.buttonTitle] = self.buttonTitle ?? ""
        clickAction[CastledReactConstants.PushNotification.ClickAction.actionType] = self.actionType.stringValue
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
