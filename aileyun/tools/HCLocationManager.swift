//
//  HCLocationManager.swift
//  aileyun
//
//  Created by huchuang on 2017/8/2.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationResultBlock = (_ loc: CLLocation?, _ errorMsg: String?) -> ()

class HCLocationManager: NSObject {

    
    var isOnce: Bool = false
    
    static let shareInstance = HCLocationManager()
    
    var location : CLLocation? {
        didSet{
            if location != nil {
                resultBlock!(location, "成功获取位置")
            }
        }
    }
    
    lazy var locationM: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    var resultBlock: LocationResultBlock?
    
    func checkAuthorization()->Bool{
        
        HCPrint(message: "checkAuthorization   *****  true/false")
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            return true
        }else{
            let alertController = UIAlertController(title: "提醒",
                                                    message: "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许app使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
                let url = URL.init(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }
            alertController.addAction(tempAction)
            alertController.addAction(callAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            return false
        }
    }
    
    func requestAuthorization(){
        // 请求授权
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            let not = Notification.init(name: NSNotification.Name.init(LOCATION_AUTH), object: nil, userInfo: nil)
            NotificationCenter.default.post(not)
        }else if status == .denied{
            let not = Notification.init(name: NSNotification.Name.init(LOCATION_AUTH), object: nil, userInfo: nil)
            NotificationCenter.default.post(not)
        }else{
            locationM.requestWhenInUseAuthorization()
        }
        
    }
    
    func getCurrentLocation(isOnce: Bool, resultBlock: @escaping LocationResultBlock){
        
        self.isOnce = isOnce
        self.location = nil
        
        // 1. 记录block
        self.resultBlock = resultBlock
        
        // 2. 在合适的地方执行
        if CLLocationManager.locationServicesEnabled() {
            locationM.startUpdatingLocation()
            HCPrint(message: "开始定位")
        }else {
            if self.resultBlock != nil {
                self.resultBlock!(nil, "当前没有开启定位服务")
            }
        }
    }
    
    func cancelUpdateLocation(){
        locationM.stopUpdatingLocation()
        if self.resultBlock != nil {
            self.resultBlock!(nil, "定位取消")
        }
    }
    
}


extension HCLocationManager : CLLocationManagerDelegate {

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        HCPrint(message: error)
        manager.stopUpdatingLocation()
        if self.resultBlock != nil {
            self.resultBlock!(nil, "定位出错")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else {
            manager.stopUpdatingLocation()
            if resultBlock != nil {
                resultBlock!(nil, "没有获取到位置信息")
            }
            return
        }
        
        //防止多次定位
        if location == nil {
            location = loc
        }
        
        if isOnce {
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var sendNote = true
      
        switch status {
        case .denied:
            HCShowInfo(info: "定位服务被拒绝")
        case .restricted:
            HCShowInfo(info: "定位服务被限制")
        case .notDetermined:
            HCShowInfo(info: "定位服务未授权")
            sendNote = false
        default:
            HCShowInfo(info: "定位服务已授权")
        }
        
        if sendNote  == true {
            let not = Notification.init(name: NSNotification.Name.init(LOCATION_AUTH), object: nil, userInfo: nil)
            NotificationCenter.default.post(not)
        }
    }
}
