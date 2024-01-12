//
//  CastledUtils.swift
//  RTNCastledNotifications
//
//  Created by antony on 27/12/2023.
//

import Castled
import Foundation


 extension CastledLocation {
     static func getLocation(from regionStr: String) -> CastledLocation {
         switch regionStr {
             case "US":
                 return .US
             case "AP":
                 return .AP
             case "INDIA":
                 return .INDIA
             case "TEST":
                 return .TEST
             default:
                 return .US
         }
     }
 }

 extension CastledLogLevel {
     static func getLogLevel(from log: String) -> CastledLogLevel {
         switch log {
             case "debug":
                 return .debug
             case "error":
                 return .error
             case "info":
                 return .info
             case "none":
                 return .none
             default:
                 return .debug
         }
     }
 }

