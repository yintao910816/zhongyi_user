//
//  Common.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SnapKit
import Photos
import SDWebImage
import MJExtension

//用户信息
let kUserPhone = "kUserPhone"
let kUserDic = "kUserDic"
let kBindDic = "kBindDic"
let kUserInfoDic = "kUserInfoDic"

let kBBSToken = "kBBSToken"

let kbbsFgiUrl = "kbbsFgiUrl"
let kgetBbsTokenUrl = "kgetBbsTokenUrl"
let kfindLastestTopics = "kfindLastestTopics"

//字体
let kReguleFont = "PingFangSC-Regular"
let kBoldFont = "PingFangSC-Semibold"

let kTextSize : CGFloat = 16


let kpopAlertTime = "KpopAlertTime"



//爱乐孕
//let kScheme = "aileyun"
//let shareImgName = "孕育未来"
//let shareTitleL = "扫一扫，安装爱乐孕"
//let qrcodeName = "QRcode"
//let appName = "爱乐孕"
//let slogan = "爱乐孕，圆你一生好孕"
//let logoName = "logo144"
//let shareURL = "http://t.cn/RYUiDdR"
//let kDefaultThemeColor = UIColor.init(red: 255/255.0, green: 124/255.0, blue: 133/255.0, alpha: 1)

//第三方登录  爱乐孕相关APPID
//let weixinAppid = "wx870ac6243698c3f6"
//let weixinSecret = "a570e4ced87a8c3564217b3e8159d4f6"
//let tencentAppid = "1106159775"
//
//let kRegisterURL = "ME_SUBSCRIBE_LIST_2017"
//let kappID = "1087377513"
//
//let KUMengKey = "59ce1ed5677baa60240008c6"




//鼓楼
//let NaviAppkey = "S7yrGBFS2q"
//let NaviMapId = "21VQVWzIrr"

//let kScheme = "gulou"
//let shareImgName = "GL-logo"
//let shareTitleL = "扫一扫，安装鼓楼生殖"
//let qrcodeName = "gulouQRCode"
//let appName = "鼓楼生殖"
//let slogan = "鼓楼生殖，助您一生好孕"
//let logoName = "GL-logo"
//let shareURL = "http://t.cn/RNhs1l9"
//let kDefaultThemeColor = UIColor.init(red: 233/255.0, green: 84/255.0, blue: 103/255.0, alpha: 1)

//第三方登录 鼓楼相关APPID
//let weixinAppid = "wx6bffd984efe7e7f9"
//let weixinSecret = "f8b1f4a4d3631d924127e4b507d126a8"
//let tencentAppid = "1106307838"

//let kRegisterURL = "ME_SUBSCRIBE_LIST_2017"
//let kappID = "1241588748"

//let KUMengKey = "5a30e0a1b27b0a112a0001a6"




//中一
let kScheme = "zhongyi"
let shareImgName = "zhongYSlogan"
let shareTitleL = "扫一扫，安装中一助孕宝"
let qrcodeName = "zhongYQRcode"
let appName = "中一助孕宝"
let slogan = "中一助孕宝，助您一生好孕"
let logoName = "zhongYLogo"
let shareURL = "http://t.cn/RjYabdV"
let kDefaultThemeColor = UIColor.init(red: 0/255.0, green: 175/255.0, blue: 142/255.0, alpha: 1)

//第三方登录 鼓楼相关APPID
let weixinAppid = "wx4d231938db8a9087"
let weixinSecret = "126e3f806ee39433ae4e5226a8fe3489"
let tencentAppid = "1105051247"

let kRegisterURL = "ME_SUBSCRIBE_LIST_2017"
let kappID = "1087395867"

let KUMengKey = "56dd871167e58e79d6002e0e"







//通知常量
let UPDATE_USER_INFO = "updateUserInfo"
let ALIPAY_SUCCESS = "alipay_success"
let WEIXIN_SUCCESS = "weixin_success"
let PAY_FAIL = "pay_fail"
let CLEAR_MSG_STATUS = "clearstatus"

let GO_TO_GROUP = "goToGroup"
let DELETE_ARTICLE = "deleteArticle"
let LOCATION_AUTH = "locationAuth"
let BIND_SUCCESS = "bindSuccess"


let TagLabelHeight : CGFloat = 20



typealias blankBlock = ()->()
typealias changeBlock = (_ info : String)->()
typealias imgArrBlock = ( _ info : [String], _ index : NSInteger)->()


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let KImgWidth = (SCREEN_WIDTH - 60) / 3


let kDefaultBlueColor = UIColor.init(red: 80/255.0, green: 155/255.0, blue: 202/255.0, alpha: 1)
let kSearchBtnColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 0.3)
let klightGrayColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
let kdivisionColor = UIColor.init(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)

let kTextColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
let kLightTextColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
let kNumberColor = UIColor.init(red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1)


let TypeText = "Text"
let TypeVoice  = "Voice"
let TypePic = "Picture"


let kReceiveRemoteNote = "kReceiveRemoteNote"



//系统自带字体
//        HCPrint(message: UIFont.familyNames)
//        let arr = UIFont.familyNames
//        for i in arr {
//            HCPrint(message: UIFont.fontNames(forFamilyName: i))
//        }



func HCTextSize(_ label : UILabel) -> CGSize {
    let maxSize = CGSize.init(width: label.frame.size.width, height: 9999)
    let textSize = (label.text! as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil).size
    return textSize
}

func HCGetSize(content : NSString, maxWidth : CGFloat, font : UIFont) -> CGSize {
    let maxSize = CGSize.init(width: maxWidth, height: 9999)
    let textSize = content.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    return textSize
}

func HCPrint<T>(message: T,
             logError: Bool = false,
             file: String = #file,
             method: String = #function,
             line: Int = #line){
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}

func HCShowInfo(info : String){
    SVProgressHUD.showInfo(withStatus: info)
}

func HCShowError(info : String){
    SVProgressHUD.showError(withStatus: info)
}

func FindRealClassForDicValue(dic : [String : Any]){
    for key in dic.keys{
        let value = dic[key]
        let ob = value as AnyObject
        
        let s = "var \(key) : \(ob.classForCoder) ?"
        let tempS = s.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ") ", with: "").replacingOccurrences(of: "NSString", with: "String")
        
        print(tempS)
    }
}

func createImage(color: UIColor) -> UIImage? {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? nil
}

// 随机颜色
func randomColor()-> UIColor{
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let alpha = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    
    return UIColor.init(red:red, green:green, blue:blue , alpha: alpha)
}

//显示消息
func showAlert(title:String, message:String){
    
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true,
                                                                completion: nil)
}

func showAlert(title : String, message : String, callback : @escaping (()->())){
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
    }
    let callAction = UIAlertAction(title: "好的", style: .default) { (action) in
        callback()
    }
    alertController.addAction(tempAction)
    alertController.addAction(callAction)
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
}

func showMessage(s : String){
    let alertController = UIAlertController(title: s,
                                            message: nil, preferredStyle: .alert)
    //显示提示框
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    //两秒钟后自动消失
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        alertController.dismiss(animated: false, completion: nil)
    }
}

func checkIsPhone(_ number : String)->(Bool){
    let regex = "^1\\d{10}$"
    let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with:number)
}


// 相册权限
func checkPhotoLibraryPermissions() -> Bool {
    
    let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted || library == PHAuthorizationStatus.notDetermined){
        return false
    }else {
        return true
    }
}

func authorizationForPhotoLibrary(confirmBlock : @escaping blankBlock){
    
    PHPhotoLibrary.requestAuthorization { (status) in
        if status == PHAuthorizationStatus.authorized{
            DispatchQueue.main.async {
                confirmBlock()
            }
        }else if status == PHAuthorizationStatus.denied{
            HCShowError(info: "未能获取图片！")
        }
    }
}

// 相机权限
func checkCameraPermissions() -> Bool {
    
    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForCamera(confirmBlock : @escaping blankBlock){
    
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启相机！")
        }
    }
}


// 麦克风权限
func checkMicrophonePermissions() -> Bool {
    
    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForMicrophone(confirmBlock : @escaping blankBlock){
    
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启语音！")
        }
    }
    
}


func HC_getTopAndBottomSpace()->(CGFloat, CGFloat){
    //兼容iPhone X
    var cutTop : CGFloat!
    var cutBottom : CGFloat!
    if #available(iOS 11.0, *) {
        if SCREEN_HEIGHT == 812 {   //iphone X
            let top = UIApplication.shared.keyWindow?.safeAreaInsets.top
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
            cutTop = top!
            cutBottom = bottom!
        }else{
            cutTop = 20
            cutBottom = 0
        }
    } else {
        cutTop = 20
        cutBottom = 0
    }
    return (cutTop, cutBottom)
}


extension UIImageView {
    
    func HC_setImageFromURL(urlS : String, placeHolder : String){
        if urlS.contains("http"){
            self.sd_setImage(with: URL.init(string: urlS), placeholderImage: UIImage.init(named: placeHolder), options: .queryMemoryData, completed: nil)
        }else{
            self.sd_setImage(with: URL.init(string: IMAGE_URL + urlS), placeholderImage: UIImage.init(named: placeHolder), options: .queryMemoryData, completed: nil)
        }
    }
    
    func HC_setImage(urlS : String){
        if urlS.contains("http"){
            self.sd_setImage(with: URL.init(string: urlS), completed: nil)
        }else{
            self.sd_setImage(with: URL.init(string: IMAGE_URL + urlS), completed: nil)
        }
    }
}

extension String {
    
    func md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}


