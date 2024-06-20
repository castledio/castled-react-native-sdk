//
//  CastledInbox.swift
//  RTNCastledNotifications
//
//  Created by antony on 18/06/2024.
//

import Castled
import CastledInbox
import Foundation
import UIKit

extension RTNCastledNotifications: CastledInboxViewControllerDelegate {
    @objc func showAppInbox(_ configs: NSDictionary?) {
        DispatchQueue.main.async {
            var inboxConfigs: CastledInboxDisplayConfig?
            if let configs = configs {
                inboxConfigs = CastledInboxDisplayConfig()
                inboxConfigs?.backButtonImage = UIImage(named: configs["emptyMessageViewText"] as? String ?? "")
                inboxConfigs?.emptyMessageViewText = configs["emptyMessageViewText"] as? String ?? ""
                inboxConfigs?.emptyMessageViewTextColor = UIColor(hexString: configs["emptyMessageViewTextColor"] as? String ?? "#000000")
                inboxConfigs?.hideBackButton = configs["hideBackButton"] as? Bool ?? false
                inboxConfigs?.inboxViewBackgroundColor = UIColor(hexString: configs["inboxViewBackgroundColor"] as? String ?? "#ffffff")
                inboxConfigs?.navigationBarBackgroundColor = UIColor(hexString: configs["navigationBarBackgroundColor"] as? String ?? "#ffffff")
                inboxConfigs?.navigationBarTitle = configs["navigationBarTitle"] as? String ?? "App Inbox"
                inboxConfigs?.navigationBarButtonTintColor = UIColor(hexString: configs["navigationBarTitleColor"] as? String ?? "#000000")
                inboxConfigs?.loaderTintColor = UIColor(hexString: configs["loaderTintColor"] as? String ?? "#808080")

                inboxConfigs?.showCategoriesTab = configs["showCategoriesTab"] as? Bool ?? true
                inboxConfigs?.tabBarDefaultBackgroundColor = UIColor(hexString: configs["tabBarDefaultBackgroundColor"] as? String ?? "#ffffff")
                inboxConfigs?.tabBarSelectedBackgroundColor = UIColor(hexString: configs["tabBarSelectedBackgroundColor"] as? String ?? "#ffffff")
                inboxConfigs?.tabBarDefaultTextColor = UIColor(hexString: configs["tabBarDefaultTextColor"] as? String ?? "#000000")
                inboxConfigs?.tabBarSelectedTextColor = UIColor(hexString: configs["tabBarSelectedTextColor"] as? String ?? "#3366CC")
                inboxConfigs?.tabBarIndicatorBackgroundColor = UIColor(hexString: configs["tabBarIndicatorBackgroundColor"] as? String ?? "#3366CC")
            }
            let inboxVC = CastledInbox.sharedInstance.getInboxViewController(withUIConfigs: inboxConfigs, andDelegate: self)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController
            {
                var topController = rootViewController
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                // let navigationController = UINavigationController(rootViewController: inboxVC)
                inboxVC.modalPresentationStyle = .fullScreen
                topController.present(inboxVC, animated: true, completion: nil)
            }
        }
    }

    @objc func getInboxUnreadCount(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        resolve(CastledInbox.sharedInstance.getInboxUnreadCount())
    }

    public func didSelectedInboxWith(_ buttonAction: CastledButtonAction, inboxItem: CastledInboxItem) {
        RTNCastledNotificationManager.shared.notificationClicked(withNotificationType: .inbox, buttonAction: buttonAction, userInfo: [:])
    }
}
