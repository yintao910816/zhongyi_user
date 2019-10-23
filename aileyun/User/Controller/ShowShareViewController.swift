//
//  ShowShareViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/7/14.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ShowShareViewController: BaseViewController, QQApiInterfaceDelegate{
    let bagV = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 120))
    
    let QQBtn = ShareButton()
    
    let QQzoneBtn = ShareButton()
    
    let WeiXinBtn = ShareButton()
    
    let WXFriendsBtn = ShareButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "分享app"
        
        let space = AppDelegate.shareIntance.space
        let contV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        contV.backgroundColor = UIColor.white
        self.view.addSubview(contV)
        
        let titleL = UILabel()
        contV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.centerX.equalTo(contV)
            make.top.equalTo(contV).offset(40)
            make.height.equalTo(15)
        }
        titleL.text = shareTitleL
        titleL.font = UIFont.systemFont(ofSize: 20)
        titleL.textColor = kDefaultThemeColor
        
        let imgV = UIImageView()
        contV.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.centerX.equalTo(contV)
            make.top.equalTo(titleL.snp.bottom).offset(50)
            make.width.height.equalTo(150)
        }
        imgV.image = UIImage.init(named: qrcodeName)
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        
        
        self.view.addSubview(bagV)
        
        // 20 + 60 * 4
        let gap = (SCREEN_WIDTH - 260)/5
        
        let containerV = UIView.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_WIDTH - 20, height: 110))
        containerV.backgroundColor = kdivisionColor
        containerV.layer.cornerRadius = 10
        
        bagV.addSubview(containerV)
        
        containerV.addSubview(QQBtn)
        QQBtn.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(gap)
            make.top.equalTo(containerV).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(75)
        }
        QQBtn.imgV.image = UIImage.init(named: "QQ01")
        QQBtn.titleL.text = "QQ"
        QQBtn.tag = 0
        QQBtn.addTarget(self, action: #selector(QQshare), for: UIControlEvents.touchUpInside)
        
        containerV.addSubview(QQzoneBtn)
        QQzoneBtn.snp.updateConstraints { (make) in
            make.left.equalTo(QQBtn.snp.right).offset(gap)
            make.centerY.equalTo(QQBtn)
            make.width.equalTo(60)
            make.height.equalTo(75)
        }
        QQzoneBtn.imgV.image = UIImage.init(named: "空间")
        QQzoneBtn.titleL.text = "QQ空间"
        QQzoneBtn.tag = 1
        QQzoneBtn.addTarget(self, action: #selector(QQshare), for: UIControlEvents.touchUpInside)
        
        containerV.addSubview(WeiXinBtn)
        WeiXinBtn.snp.updateConstraints { (make) in
            make.left.equalTo(QQzoneBtn.snp.right).offset(gap)
            make.centerY.equalTo(QQBtn)
            make.width.equalTo(60)
            make.height.equalTo(75)
        }
        WeiXinBtn.imgV.image = UIImage.init(named: "微信01")
        WeiXinBtn.titleL.text = "微信"
        WeiXinBtn.tag = 2
        WeiXinBtn.addTarget(self, action: #selector(WeiXinShare), for: UIControlEvents.touchUpInside)
        
        containerV.addSubview(WXFriendsBtn)
        WXFriendsBtn.snp.updateConstraints { (make) in
            make.left.equalTo(WeiXinBtn.snp.right).offset(gap)
            make.centerY.equalTo(QQBtn)
            make.width.equalTo(60)
            make.height.equalTo(75)
        }
        WXFriendsBtn.imgV.image = UIImage.init(named: "朋友圈")
        WXFriendsBtn.titleL.text = "朋友圈"
        WXFriendsBtn.tag = 3
        WXFriendsBtn.addTarget(self, action: #selector(WeiXinShare), for: UIControlEvents.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self]()in
            self?.bagV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 200, width: SCREEN_WIDTH, height: 120)
        }
    }
    
    @objc func WeiXinShare(btn : UIButton){
        let message = WXMediaMessage.init()
        message.title = appName
        message.description = slogan
        message.setThumbImage(UIImage.init(named: logoName))
        
        let webpageObj = WXWebpageObject.init()
        webpageObj.webpageUrl = shareURL
        
        message.mediaObject = webpageObj
        
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        
        if btn.tag == 2 {
            req.scene = Int32(WXSceneSession.rawValue)
        }else{
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        
        WXApi.send(req)
        
        self.dismiss(animated: false) {
            //
        }
        
    }
    
    @objc func QQshare(btn : UIButton){
        
        let url = URL.init(string: shareURL)!
        let img = UIImage.init(named: logoName)!
        let imgData = UIImagePNGRepresentation(img)!
        let newsObj = QQApiNewsObject.init(url: url, title: appName, description: slogan, previewImageData: imgData, targetContentType: QQApiURLTargetTypeNews)!
        let req = SendMessageToQQReq.init(content: newsObj)
        
        var sent : QQApiSendResultCode!
        if btn.tag == 0{
            sent = QQApiInterface.send(req)
        }else{
            sent = QQApiInterface.sendReq(toQZone: req)
        }
        
        handleSendResult(sendResult: sent)
        
    }
    
    
    func handleSendResult(sendResult:QQApiSendResultCode){
        var message = ""
        
        switch(sendResult){
        case EQQAPIAPPNOTREGISTED:
            message = "App未注册"
        case EQQAPIMESSAGECONTENTINVALID, EQQAPIMESSAGECONTENTNULL,
             EQQAPIMESSAGETYPEINVALID:
            message = "发送参数错误"
        case EQQAPIQQNOTINSTALLED:
            message = "QQ未安装"
        case EQQAPIQQNOTSUPPORTAPI:
            message = "API接口不支持"
        case EQQAPISENDFAILD:
            message = "发送失败"
        case EQQAPIQZONENOTSUPPORTTEXT:
            message = "空间分享不支持纯文本分享，请使用图文分享"
        case EQQAPIQZONENOTSUPPORTIMAGE:
            message = "空间分享不支持纯图片分享，请使用图文分享"
        default:
            message = "发送成功"
        }
        
        HCShowInfo(info: message)
    }
    
    // delegate
    func onResp(_ resp: QQBaseResp!) {
        //确保是对我们QQ分享操作的回调
        HCPrint(message: resp.classForCoder)
        HCPrint(message: resp)
        
        if resp.isKind(of: SendMessageToQQResp.self) {
            //QQApi应答消息类型判断（手Q -> 第三方应用，手Q应答处理分享消息的结果）
            if uint(resp.type) == ESENDMESSAGETOQQRESPTYPE.rawValue {
                let title = resp.result == "0" ? "分享成功" : "分享失败"
                var message = ""
                switch(resp.result){
                case "-1":
                    message = "参数错误"
                case "-2":
                    message = "该群不在自己的群列表里面"
                case "-3":
                    message = "上传图片失败"
                case "-4":
                    message = "用户放弃当前操作"
                case "-5":
                    message = "客户端内部处理错误"
                default: //0
                    //message = "成功"
                    break
                }
                //显示消息
                showAlert(title: title, message: message)
            }
        }
    }
    
    //处理来至QQ的请求
    func onReq(_ req : QQBaseReq!){
        print("--- onReq ---")
    }
    
    //处理QQ在线状态的回调
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        print("--- isOnlineResponse ---")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
