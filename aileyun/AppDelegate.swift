 //
//  AppDelegate.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
 import HandyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate{

    var window: UIWindow?
    
    var Login = false
    
    lazy var space : (topSpace : CGFloat, bottomSpace : CGFloat) = {
        let s = HC_getTopAndBottomSpace()
        return s
    }()
    
    // 设计成单例
    static let shareIntance : AppDelegate = {
        let tools = AppDelegate()
        return tools
    }()

    var defaultViewController : UIViewController {
        
        let dic = UserDefaults.standard.value(forKey: kUserDic) as? [String : Any]
        
        if let dic = dic{
//            UserManager.shareIntance.HCUser = HCUserModel.init(dic)
            UserManager.shareIntance.HCUser = JSONDeserializer<HCUserModel>.deserializeFrom(dict: dic)
            Login = true
        }else{
            Login = false
        }
        let loginVC = BaseNavigationController.init(rootViewController: LoginViewController())
        return Login ? MainTabBarController() : loginVC
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        IpsmapServices.setAppKey(NaviAppkey)
        
        //ipsmap位置共享
//        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.ipsReceiveShareInfo), name: NSNotification.Name.init("IpsReceiveShareInfoNotification"), object: nil)
//
//        IpsmapServices.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        WXApi.registerApp(weixinAppid, universalLink: "")
        
        UMeng(launchOptions: launchOptions)
        
        let rect = UIScreen.main.bounds
        window = UIWindow.init(frame: rect)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        return true
    }

    
//    func ipsReceiveShareInfo(noti : Notification){
//        guard noti.object != nil else {
//            return
//        }
//        let obj = noti.object as AnyObject
//        if obj.isKind(of: UIView.classForCoder()){
//            let viewJoin = obj as! UIView
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                viewJoin.perform("showInView", with: UIApplication.shared.keyWindow)
//            })
//        }
//    }
    
    
    
    func UMeng(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        let obj = UMAnalyticsConfig.init()
        obj.appKey = KUMengKey
        MobClick.start(withConfigure: obj)
        
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion = infoDictionary! ["CFBundleShortVersionString"] as? NSString
        MobClick.setVersion(Int(majorVersion?.intValue ?? 1))
        
        MobClick.setLogEnabled(true)
        
        UMessage.start(withAppkey: KUMengKey, launchOptions: launchOptions)
        
        UMessage.setLogEnabled(false)
        UMessage.setAutoAlert(false)
        
        registerNotification()
    }
    
    func registerNotification(){
        if UserDefaults.standard.value(forKey: kReceiveRemoteNote) != nil {
            let receNote = UserDefaults.standard.value(forKey: kReceiveRemoteNote) as! Bool
            if receNote == false {
                return
            }
        }
        
        if #available(iOS 10.0, *) {
            // 使用 UNUserNotificationCenter 来管理通知
            let center = UNUserNotificationCenter.current()
            //监听回调事件
            center.delegate = self
            
            //iOS 10 使用以下方法注册，才能得到授权
            center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge,UNAuthorizationOptions.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                if (granted) {
                    //点击允许
                    HCPrint(message: "注册通知成功")
                    UserDefaults.standard.set(true, forKey: kReceiveRemoteNote)
                    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
                    center.getNotificationSettings(completionHandler:{(settings:UNNotificationSettings) in
                        HCPrint(message: "UNNotificationSettings")
                    })
                } else {
                    //点击不允许
                    UserDefaults.standard.set(false, forKey: kReceiveRemoteNote)
                    HCPrint(message: "注册通知失败")
                }
            })
        } else {
            // Fallback on earlier versions
            let type = UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue
            let set = UIUserNotificationSettings.init(types: UIUserNotificationType(rawValue: type), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(set)
        }
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        IpsmapServices.sharedInstance().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        HttpRequestManager.shareIntance.HC_getUpdateLock(callback: {(isOn)in
            if isOn == true{
                HCPrint(message: "打开版本检测")
                HttpClient.shareIntance.CheckVersion()
            }else{
                HCPrint(message: "关闭版本检测")
            }
        })
        NetworkStatusTool.NetworkingStatus()
        application.applicationIconBadgeNumber = 0
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        HCPrint(message: url.absoluteString)
        
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                HCPrint(message: resultDic)
                let status = resultDic?["resultStatus"] as! String
                if status == "9000"{
                    let s = resultDic?["result"] as! String
                    do{
                        let dic = try JSONSerialization.jsonObject(with: s.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                        let tempDic = dic["alipay_trade_app_pay_response"] as! [String : Any]
                        let tradeNo = tempDic["out_trade_no"] as! String
                        //支付成功  发送通知
                        
                        let not = Notification.init(name: NSNotification.Name.init(ALIPAY_SUCCESS), object: nil, userInfo: ["tradeNo" : tradeNo])
                        NotificationCenter.default.post(not)
                    }
                    catch{}
                }else{
                    //支付失败
                    let not = Notification.init(name: NSNotification.Name.init(PAY_FAIL), object: nil, userInfo: nil)
                    NotificationCenter.default.post(not)
                }
            })
            return true
        }else if url.absoluteString.contains("tencent" + tencentAppid){
            TencentOAuth.handleOpen(url)
            let vc = ShowShareViewController()
            return QQApiInterface.handleOpen(url, delegate: vc)
        }else if url.scheme == weixinAppid{
            return WXApi.handleOpen(url, delegate: self)
        }
        
        return true
//        return IpsmapServices.sharedInstance().application(app, open: url)
    }
    
    func onReq(_ req: BaseReq!) {
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: SendAuthResp.self) {
            if resp.errCode == 0{
                let obj = resp as! SendAuthResp
                // 调本地接口获取用户信息
                HttpClient.shareIntance.getWeixinOpenId(code: obj.code!)
            }else{
                HCShowError(info: "授权失败")
            }
        }else if resp.isKind(of: PayResp.self){
            let obj = resp as! PayResp
            if obj.errCode == 0{
                //支付成功  发送通知
                let not = Notification.init(name: NSNotification.Name.init(WEIXIN_SUCCESS), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
            }else{
                //支付失败
                let not = Notification.init(name: NSNotification.Name.init(PAY_FAIL), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
            }
        }else if resp.isKind(of: SendMessageToWXResp.self){
            if resp.errCode == 0{
                //分享成功
                showAlert(title: "分享成功", message: "")
            }else{
                showAlert(title: "分享不成功", message: "")
            }
        }
    }
    
}


extension AppDelegate : UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        HCPrint(message: "didRegister notificationSetting")
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        UMessage.registerDeviceToken(deviceToken)
        
        let data = deviceToken as NSData
        let token = data.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        HCPrint(message: token)
        
        let infoDic = Bundle.main.infoDictionary
        let identif = infoDic?["CFBundleIdentifier"]
        
        let infoD = ["umengDeviceToken": token, "packageName" : identif]
        HttpRequestManager.shareIntance.HC_updateDeviceToken(infoDic: infoD as NSDictionary) { (success, msg) in
            if success == false {
                HCPrint(message: "上传token失败！")
            }else{
                HCPrint(message: "上传token成功！")
            }
        }
    }
    
    //收到远程推送消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        self.receiveRemoteNotificationForbackground(userInfo: userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let information = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于后台时的本地推送接受
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let information = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    
    func receiveRemoteNotificationForbackground(userInfo : [AnyHashable : Any]){
        HCPrint(message: userInfo)
        
        let message = userInfo["alert"] as? String ?? "alert"
        
        let tabVC = self.window?.rootViewController as! MainTabBarController
        let selVC = tabVC.selectedViewController as! UINavigationController
        
        let alertController = UIAlertController(title: "新消息提醒",
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "马上查看", style: .default, handler: {(action)->() in
            let notificationType = userInfo["notificationType"] as? String  ?? ""
            switch notificationType {
            case "21" :
                HCPrint(message: "21")
                let url = userInfo["url"] as? String ?? "http://www.ivfcn.com"
                let webVC = WebViewController()
                webVC.url = url
                selVC.pushViewController(webVC, animated: true)
            case "22" :
                HCPrint(message: "22")
                selVC.pushViewController(ConsultRecordViewController(), animated: true)
            case "23" :
                HCPrint(message: "23")
                let survey = userInfo["url"] as! String
                let webVC = WebViewController()
                webVC.url = survey
                selVC.pushViewController(webVC, animated: true)
            default :
                HCPrint(message: "default")
                selVC.pushViewController(MessageViewController(), animated: true)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

