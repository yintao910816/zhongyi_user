//
//  UserManager.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/25.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserManager: NSObject {
    //之前的接口获取
    var localUser : LocalUserModel?
    //微信对应
    var currentUser : UserModel?
    var UserInfoModel : UserInfoModel?
    //QQ对应
    var QQModel : UserQQModel?
    
    //新设计的接口
    var HCUser : HCUserModel? {
        didSet{
            if HCUser != nil{
                HCPrint(message: "registerRemoteNotification")
                UMessage.registerForRemoteNotifications()
                
//                guard let alias = HCUser?.phone else{return}
//                var hosId : String!
//                if HCUser?.hospitalId != nil {
//                    hosId = String.init(format: "%d", (HCUser?.hospitalId?.intValue)!)
//                }else{
//                    hosId = "0"
//                }
//                UMessage.setAlias(alias, type: hosId, response: { (result, err) in
//                    //
//                })
                
            }else{
                HCPrint(message: "unregisterRemoteNotification")
                UMessage.unregisterForRemoteNotifications()
            }
        }
    }
    var HCUserInfo : HCUserInfoModel?

    var BindedModel : BindedModel?
    
    // 设计成单例
    static let shareIntance : UserManager = {
        let tools = UserManager()
        return tools
    }()

    //弃用
    func loginBy(num : String, password : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        HttpRequestManager.shareIntance.loginBy(userName: num, password: password) { [weak self](success, model) in
            if success == true {
                self?.localUser = model
                
                callback(true, "登录成功！")
            }else{
                callback(false, "登录失败！")
            }
        }
    }
    
    func HC_login(uname: String, pwd: String, callback: @escaping (Bool, String) -> ()){
        HttpRequestManager.shareIntance.HC_login(uname: uname, pwd: pwd) { (success, msg) in
            callback(success, msg)
        }
    }
    
    func updateUserInfo(callback : @escaping (Bool)->()){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
            if success == true {
                SVProgressHUD.dismiss()
                callback(true)
            }else{
                callback(false)
            }
        })
    }
    
    func logout(){
        HttpClient.shareIntance.cancelAllRequest()
        
        //注销推送
        UserManager.shareIntance.HCUser = nil
        UserManager.shareIntance.HCUserInfo = nil
        UserManager.shareIntance.BindedModel = nil
        
        //清空用户信息
        UserDefaults.standard.removeObject(forKey: kUserDic)
        UserDefaults.standard.removeObject(forKey: kUserInfoDic)
        UserDefaults.standard.removeObject(forKey: kBindDic)
        
        UserDefaults.standard.removeObject(forKey: kBBSToken)
        
        //跳转登录界面
        UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
    }
    
    
}
