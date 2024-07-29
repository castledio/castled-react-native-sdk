//
//  CastledConstants.swift
//  RTNCastledNotifications
//
//  Created by antony on 29/07/2024.
//

import Foundation

enum CastledReactConstants {
    static let castled = "castled"
    enum PushNotification {
        static let notificationId = "notificationId"
        static let body = "body"
        static let badge = "badge"
        static let aps = "aps"
        static let category = "category"
        static let threadId = "threadId"
        static let contentAvailable = "contentAvailable"
        static let interruptionLevel = "interruptionLevel"
        static let relevanceScore = "relevanceScore"
        static let mutableContent = "mutableContent"
        static let sound = "sound"
        static let alert = "alert"
        static let title = "title"
        static let subtitle = "subtitle"
        static let categoryActions = "category_actions"
        static let actionComponents = "actionComponents"
        static let actionButtons = "actionButtons"
        static let castledNotificationId = "castled_notification_id"
        static let shouldIncrementBadge = "shouldIncrementBadge"
        enum ClickAction {
            static let clickActionUri = "clickActionUri"
            static let keyVals = "keyVals"
            static let buttonTitle = "buttonTitle"
            static let actionType = "actionType"
        }
    }

    enum CastledConfigs {
        static let appId = "appId"
        static let enableAppInbox = "enableAppInbox"
        static let enableInApp = "enableInApp"
        static let enablePush = "enablePush"
        static let enableTracking = "enableTracking"
        static let enableSessionTracking = "enableSessionTracking"
        static let skipUrlHandling = "skipUrlHandling"
        static let inAppFetchIntervalSec = "inAppFetchIntervalSec"
        static let sessionTimeOutSec = "sessionTimeOutSec"
        static let appgroupId = "appgroupId"
        static let location = "location"
        static let logLevel = "logLevel"
    }

    enum CastlediInbox {
        static let backButtonImage = "backButtonImage"
        static let emptyMessageViewText = "emptyMessageViewText"
        static let emptyMessageViewTextColor = "emptyMessageViewTextColor"
        static let hideBackButton = "hideBackButton"
        static let inboxViewBackgroundColor = "inboxViewBackgroundColor"
        static let navigationBarBackgroundColor = "navigationBarBackgroundColor"
        static let navigationBarTitle = "navigationBarTitle"
        static let navigationBarTitleColor = "navigationBarTitleColor"
        static let loaderTintColor = "loaderTintColor"
        static let showCategoriesTab = "showCategoriesTab"
        static let tabBarDefaultBackgroundColor = "tabBarDefaultBackgroundColor"
        static let tabBarSelectedBackgroundColor = "tabBarSelectedBackgroundColor"
        static let tabBarDefaultTextColor = "tabBarDefaultTextColor"
        static let tabBarSelectedTextColor = "tabBarSelectedTextColor"
        static let tabBarIndicatorBackgroundColor = "tabBarIndicatorBackgroundColor"
    }

    enum CastledListeners: String, CaseIterable {
        case CastledListenerPushReceived = "onReceivedNotification"
        case CastledListenerPushClicked = "onNotificationClick"
        case CastledListenerPushDismissed = "onDismissedNotification"
        case CastledListenerInAppMessageReceived = "onReceivedInAppMessage"
        case CastledListenerInAppMessageClicked = "onInAppMessageClick"
        case CastledListenerInAppMessageDismissed = "onDismissedInAppMessage"
        case CastledListenerInboxNotificationClicked = "onInboxNotificationClick"
    }
}
