//
//  HttpClient.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation
import AFNetworking
import SVProgressHUD

class HttpClient {
    
    lazy var HCmanager : AFHTTPSessionManager = {
        let mg = AFHTTPSessionManager.init()
        mg.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json", "text/json", "text/javascript", "text/html", "text/plain") as? Set<String>
        mg.requestSerializer.timeoutInterval = 30
        mg.securityPolicy = AFSecurityPolicy.init(pinningMode: AFSSLPinningMode.none)
        
        mg.securityPolicy.allowInvalidCertificates = true
        mg.securityPolicy.validatesDomainName = false
        
        return mg
    }()
    
    
    // 设计成单例
    static let shareIntance : HttpClient = {
        let tools = HttpClient()
        return tools
    }()
    
    // 定义闭包别名
    typealias HttpRequestCompleted = (_ result : Any, _ ccb : CommonCallBack)->()
}

extension HttpClient {
    
    
    func POST(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted) {
        let parameDic = addCommonParameters(parameters)
        POST(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        GET(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
        HCPrint(message: URLString)
        HCPrint(message: parameters)
        
        HCmanager.get(URLString, parameters: parameters, progress: { (progress) in
            //
        }, success: { ( task : URLSessionDataTask, responseObject : Any?) in
            
            HCPrint(message: URLString)
//            HCPrint(message: responseObject)
            
            let ccb = CommonCallBack.init()
            let resDic = responseObject as! NSDictionary
            
            let tempCode = resDic.value(forKey: "infoCode") as? NSInteger
            
            if let tempCode = tempCode {
                ccb.code = tempCode
            }else{
                ccb.code = resDic.value(forKey: "code") as! NSInteger
            }
           
            self.dealWithCode(code: ccb.code)
            
            let tempS = resDic.value(forKey: "message") as? String
            
            if let tempS = tempS {
                ccb.msg = tempS
            }else{
                let s = resDic.value(forKey: "msg") as? String
                if let s = s {
                    ccb.msg = s
                }
            }
            
            ccb.data = resDic.value(forKey: "data") 
            
            callBack(responseObject, ccb)
            
        }) { ( task : URLSessionDataTask?, error : Error) in
            
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            
            HCPrint(message: URLString)
            HCPrint(message: error)
            
            callBack("", ccb)
        }

        
    }
    
    
    func GET_BBS_token(_ URLString : String, parameters : NSDictionary, callBack : @escaping (Bool, String)->()){
        
//        HCPrint(message: URLString)
//        HCPrint(message: parameters)
        
        HCmanager.get(URLString, parameters: parameters, progress: { (progress) in
            //
        }, success: { ( task : URLSessionDataTask, responseObject : Any?) in
            
            HCPrint(message: URLString)
//            HCPrint(message: responseObject)
            
            let resDic = responseObject as! NSDictionary
            
            let code = resDic.value(forKey: "code") as! String
            
            if code == "200"{
                let tempS = resDic.value(forKey: "data")  as! String
                callBack(true, tempS)
            }else{
                callBack(false, "")
            }
        }) { ( task : URLSessionDataTask?, error : Error) in
            HCPrint(message: "出错")
            callBack(false, "")
        }
    }

    
    
    func POST(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
        HCPrint(message: URLString)
        HCPrint(message: parameters)

        HCmanager.post(URLString, parameters: parameters, progress: { (progress) in
            //
        }, success: { [weak self](task : URLSessionDataTask, responseObject : Any) in
            
            HCPrint(message: URLString)
//            HCPrint(message: responseObject)
            
            let ccb = CommonCallBack.init()
            
            let resDic = responseObject as? NSDictionary
            
            guard let dic = resDic else{
                callBack("", ccb)
                return
            }
            
            let tempCode = dic.value(forKey: "infoCode") as? NSInteger
            
            if let tempCode = tempCode {
                ccb.code = tempCode
            }else{
                ccb.code = dic.value(forKey: "code") as! NSInteger
            }
            
            self?.dealWithCode(code: ccb.code)
            
            let tempS = dic.value(forKey: "message") as? String
            
            if let tempS = tempS {
                ccb.msg = tempS
            }else{
                let s = dic.value(forKey: "msg") as? String
                if let s = s {
                    ccb.msg = s
                }
            }
            
            ccb.data = dic.value(forKey: "data")
            
            callBack(responseObject, ccb)
            
        }) { [weak self](task : URLSessionDataTask?, error : Error) in
            
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if (self?.HCmanager.reachabilityManager.isReachable)! {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
        
    }
    
    func dealWithCode(code : NSInteger){
        
        HCPrint(message: code)
        
        if code == 401 {
            UserManager.shareIntance.logout()
        }
    
    }
    
    
    func addCommonParameters(_ param : NSDictionary? ) -> NSDictionary{

        var dic = NSMutableDictionary.init()
        if let param = param{
            dic = NSMutableDictionary.init(dictionary: param)
        }
        
        dic["token"] = UserManager.shareIntance.HCUser?.token ?? ""
        dic["deviceType"] = "iOS"
        
        let infoDic = Bundle.main.infoDictionary      //CFBundleIdentifier
        let version = infoDic?["CFBundleShortVersionString"] as! String
        dic["version"] = version
        
        let sysVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.modelName
        let info = sysVersion + "," + deviceModel + ",apple," + version
        dic["deviceInfo"] = info
        
        return dic as NSDictionary
    }
    
}

extension HttpClient {
    
    func uploadImage(_ URLString : String, parameters : NSDictionary?, imageArr : [UIImage], callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        
//        HCPrint(message: URLString)
//        HCPrint(message: parameDic)
        
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            for i in 0..<imageArr.count{
                let imageFile = imageArr[i]
                let fileN = String.init(format: "file%d", i)
                let imageN = String.init(format: "image%d.jpg", i)
                if imageFile.isKind(of: UIImage.classForCoder()){
                    formData.appendPart(withFileData: UIImageJPEGRepresentation(imageFile, 0.2)!, name: fileN, fileName: imageN, mimeType: "image/jpg")
                }
            }
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
//            HCPrint(message: any)
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            
            let tempCode = resDic.value(forKey: "infoCode") as? NSInteger
            
            if let tempCode = tempCode {
                ccb.code = tempCode
            }else{
                ccb.code = resDic.value(forKey: "code") as! NSInteger
            }
            
            self.dealWithCode(code: ccb.code)
            
            let tempS = resDic.value(forKey: "message") as? String
            
            if let tempS = tempS {
                ccb.msg = tempS
            }else{
                let s = resDic.value(forKey: "msg") as? String
                if let s = s {
                    ccb.msg = s
                }
            }
            
            ccb.data = resDic.value(forKey: "data")
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }
    
    
    // 单张图片上传
    func uploadSingleImage(_ URLString : String, parameters : NSDictionary?, img : UIImage, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        
//        HCPrint(message: URLString)
//        HCPrint(message: parameDic)
        
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            let fileN = "file"
            let imageN = "img.jpg"
            formData.appendPart(withFileData: UIImageJPEGRepresentation(img, 0.1)!, name: fileN, fileName: imageN, mimeType: "image/jpg")
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
//            HCPrint(message: any)
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            
            ccb.code = resDic.value(forKey: "code") as! NSInteger
            
            ccb.msg = resDic.value(forKey: "message") as! String
           
            ccb.data = resDic.value(forKey: "data")
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }

    

    func uploadVoice(_ URLString : String, parameters : NSDictionary?, voiceFile : String, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            
            let da = NSData.init(contentsOfFile: voiceFile)
            formData.appendPart(withFileData: da! as Data, name: "file01", fileName: "voice01.amr", mimeType: "audio/AMR")
            
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            
            let tempCode = resDic.value(forKey: "infoCode") as? NSInteger
            
            if let tempCode = tempCode {
                ccb.code = tempCode
            }else{
                ccb.code = resDic.value(forKey: "code") as! NSInteger
            }
            
            self.dealWithCode(code: ccb.code)
            
            let tempS = resDic.value(forKey: "message") as? String
            
            if let tempS = tempS {
                ccb.msg = tempS
            }else{
                let s = resDic.value(forKey: "msg") as? String
                if let s = s {
                    ccb.msg = s
                }
            }
            
            ccb.data = resDic.value(forKey: "data")
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.code = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.msg = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.msg = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }

    func downloadVoice(url : URL, destiPath : String, callback : @escaping blankBlock){
        
        let request = URLRequest.init(url: url)
        let task = HCmanager.downloadTask(with: request, progress: { (progress) in
        }, destination: { (url, response) -> URL in
            return URL.init(fileURLWithPath: destiPath)
        }) { (response, url, error) in
            //  完成一次来一次
            callback()
        }
        
        task.resume()
    }
    
}

extension HttpClient {
    //版本检测
    func CheckVersion(){
        
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! NSString
        HCPrint(message: currentVersion)

        let localArray = currentVersion.components(separatedBy: ".")
        
        let urlS = "http://itunes.apple.com/lookup?id=" + kappID
        
        HCmanager.get(urlS, parameters: nil, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let response = any as! NSDictionary
            let arr = response["results"] as! NSArray
            let dic = arr[0] as! NSDictionary
            let versionS = dic["version"] as! NSString
            let trackViewUrlS = dic["trackViewUrl"] as! String
            
            HCPrint(message: versionS)
            let versionArray = versionS.components(separatedBy: ".")
            
            for i in 0..<versionArray.count{
                if i > localArray.count - 1 {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在iTunes界面点击下方的更新按钮，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                let verInt = versionArray[i] as! NSString
                let locInt = localArray[i] as! NSString
                if verInt.intValue > locInt.intValue {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在iTunes界面点击下方的更新按钮，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }else if verInt.intValue < locInt.intValue {
                    return
                }
            }
            
        }) { (task, error) in
            HCPrint(message: "版本检测出错！")
        }
    }
}

extension HttpClient {
    
    func getWeixinOpenId(code : String){
        let appID = weixinAppid
        let secret = weixinSecret
        let urlS = String.init(format: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appID, secret, code)
        SVProgressHUD.show()
        DispatchQueue.global().async {[weak self]() in
            self?.HCmanager.get(urlS, parameters: nil, progress: { (progress) in
                //
            }, success: { (task, any) in
                let dic = any as! Dictionary<String, Any>
                
                let accessToken = dic["access_token"] as! String
                let openid = dic["openid"] as! String
                
                HCPrint(message: openid)
                
                // 调服务器接口  是否需要绑定？
                HttpRequestManager.shareIntance.HC_thirdLogin(accessToken: accessToken, openId: openid, loginType: "weixin", appid: weixinAppid, callback: {(success, infoCode, msg) in
                    if infoCode == 200 {
                        HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
                            if success == true {
                                SVProgressHUD.dismiss()
                                UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                            }else{
                                HCShowError(info: msg)
                            }
                        })
                    }else if infoCode == 201{
                        //绑定手机
                        SVProgressHUD.dismiss()
                        let bindVC = RegisterViewController()
                        bindVC.isBind = true
                        bindVC.bindInfo = ["accessToken" : accessToken, "openId" : openid, "loginType" : "weixin", "appId" : weixinAppid]
                        let naviVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
                        DispatchQueue.main.async {
                        naviVC.pushViewController(bindVC, animated: true)
                        }
                    }else{
                        //出错
                        HCShowError(info: msg)
                    }
                })
            }, failure: { (task, err) in
                HCPrint(message: err)
                SVProgressHUD.dismiss()
            })
        }
    }
    
    func getUserInfo(){
        
        let user = UserManager.shareIntance.currentUser
        let access_token = (user?.access_token)!
        let openid = (user?.openid)!
        let urlS = String.init(format: "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", access_token, openid)
        
        DispatchQueue.global().async {[weak self]() in
            self?.HCmanager.get(urlS, parameters: nil, progress: { (progress) in
                //
            }, success: { (task, any) in
                let dic = any as! Dictionary<String, Any>
                UserManager.shareIntance.UserInfoModel = UserInfoModel.init(dic)
                HCPrint(message: dic)
            }, failure: { (task, err) in
                HCPrint(message: err)
            })
        }
    }

    func cancelAllRequest(){
        for t in HCmanager.tasks {
            t.cancel()
        }
    }
    
}


