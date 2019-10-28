//
//  NetworkStateTool.swift
//  aileyun
//
//  Created by huchuang on 2017/10/23.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import CoreTelephony
import AFNetworking

class NetworkStatusTool: NSObject {
    
//    static let shareIntance : NetworkStatusTool = {
//        let tools = NetworkStatusTool()
//        return tools
//    }()

    static func NetworkPermissionStatus(){
        if #available(iOS 9.0, *) {
            let cellularData = CTCellularData.init()
            let state = cellularData.restrictedState
            switch state {
            case .restricted:
                HCPrint(message: "Restricted")
                showAlert(title: "蜂窝数据没有授权", message: "以免影响使用，请到设置里面打开蜂窝数据开关", callback: {
                    let url = URL.init(string: UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                })
            case .notRestricted:
                HCPrint(message: "NotRestricted")
                showAlert(title: "提醒", message: "无法连接到互联网，请检查网络设置")
            case .restrictedStateUnknown:
                HCPrint(message: "RestrictedStateUnknown")
                showAlert(title: "蜂窝数据没有授权", message: "以免影响使用，请到设置里面打开蜂窝数据开关", callback: {
                    let url = URL.init(string: UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.openURL(url!)
                    }
                })
            }
        } else {
            HCPrint(message: "below iOS 9")
        }
    }
    
    static func NetworkingStatus(){
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            switch status{
            case .notReachable:
                HCPrint(message: "notReachable")
                NetworkPermissionStatus()
            case .reachableViaWiFi:
                HCPrint(message: "WiFi")
            case .reachableViaWWAN:
                HCPrint(message: "WAN")
            case .unknown:
                HCPrint(message: "unknown")
            }
            AFNetworkReachabilityManager.shared().stopMonitoring()
        }
    }
}
