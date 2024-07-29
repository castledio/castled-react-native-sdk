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
                inboxConfigs?.backButtonImage = UIImage(named: configs[CastledReactConstants.CastlediInbox.backButtonImage] as? String ?? "")
                inboxConfigs?.emptyMessageViewText = configs[CastledReactConstants.CastlediInbox.emptyMessageViewText] as? String ?? ""
                inboxConfigs?.emptyMessageViewTextColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.emptyMessageViewTextColor] as? String ?? "#000000")
                inboxConfigs?.hideBackButton = configs[CastledReactConstants.CastlediInbox.hideBackButton] as? Bool ?? false
                inboxConfigs?.inboxViewBackgroundColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.inboxViewBackgroundColor] as? String ?? "#ffffff")
                inboxConfigs?.navigationBarBackgroundColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.navigationBarBackgroundColor] as? String ?? "#ffffff")
                inboxConfigs?.navigationBarTitle = configs[CastledReactConstants.CastlediInbox.navigationBarTitle] as? String ?? "App Inbox"
                inboxConfigs?.navigationBarButtonTintColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.navigationBarTitleColor] as? String ?? "#000000")
                inboxConfigs?.loaderTintColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.loaderTintColor] as? String ?? "#808080")
                inboxConfigs?.showCategoriesTab = configs[CastledReactConstants.CastlediInbox.showCategoriesTab] as? Bool ?? true
                inboxConfigs?.tabBarDefaultBackgroundColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.tabBarDefaultBackgroundColor] as? String ?? "#ffffff")
                inboxConfigs?.tabBarSelectedBackgroundColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.tabBarSelectedBackgroundColor] as? String ?? "#ffffff")
                inboxConfigs?.tabBarDefaultTextColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.tabBarDefaultTextColor] as? String ?? "#000000")
                inboxConfigs?.tabBarSelectedTextColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.tabBarSelectedTextColor] as? String ?? "#3366CC")
                inboxConfigs?.tabBarIndicatorBackgroundColor = UIColor(hexString: configs[CastledReactConstants.CastlediInbox.tabBarIndicatorBackgroundColor] as? String ?? "#3366CC")
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
