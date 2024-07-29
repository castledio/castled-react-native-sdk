//
//  NSDictionary+Extensions.swift
//  RTNCastledNotifications
//
//  Created by antony on 29/07/2024.
//

import Foundation
@_spi(CastledInternal) import Castled

extension NSDictionary {
    func toCastledConfig() -> CastledConfigs {
        let config = CastledConfigs.initialize(appId: (self[CastledReactConstants.CastledConfigs.appId] as? String) ?? "")
        config.enableAppInbox = (self[CastledReactConstants.CastledConfigs.enableAppInbox] as? Bool) ?? false
        config.enableInApp = (self[CastledReactConstants.CastledConfigs.enableInApp] as? Bool) ?? false
        config.enablePush = (self[CastledReactConstants.CastledConfigs.enablePush] as? Bool) ?? false
        config.enableTracking = (self[CastledReactConstants.CastledConfigs.enableTracking] as? Bool) ?? false
        config.enableSessionTracking = (self[CastledReactConstants.CastledConfigs.enableSessionTracking] as? Bool) ?? true
        config.skipUrlHandling = (self[CastledReactConstants.CastledConfigs.skipUrlHandling] as? Bool) ?? false
        config.inAppFetchIntervalSec = Int((self[CastledReactConstants.CastledConfigs.inAppFetchIntervalSec] as? String) ?? "900") ?? 900
        config.sessionTimeOutSec = (self[CastledReactConstants.CastledConfigs.sessionTimeOutSec] as? Int) ?? 900
        config.appGroupId = (self[CastledReactConstants.CastledConfigs.appgroupId] as? String) ?? ""
        config.location = CastledLocation.getLocation(from: (self[CastledReactConstants.CastledConfigs.location] as? String) ?? "US")
        config.logLevel = CastledLogLevel.getLogLevel(from: (self[CastledReactConstants.CastledConfigs.logLevel] as? String) ?? "debug")
        return config
    }
}
