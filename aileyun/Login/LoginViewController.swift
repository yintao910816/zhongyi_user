//
//  LoginViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    let containerV = UIView.init(frame: CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 300))
    
    let aileyunImgV = UIImageView.init(image: UIImage.init(named: shareImgName))
    
    lazy var gradientL : CAGradientLayer = {
        let l = CAGradientLayer.init()
        l.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
//        let pingColor = UIColor.init(red: 249/255.0, green: 218/255.0, blue: 219/255.0, alpha: 1)
        let pingColor = kDefaultThemeColor
        l.colors = [pingColor.cgColor, UIColor.white.cgColor]
        return l
    }()
    
    let cellphoneTF = UITextField()
    let passwordTF = UITextField()
    
    let weixinBtn = loginBtn()
    let QQBtn = loginBtn()
    
    var tencentOAuth : TencentOAuth?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false
    
        let rightItem = UIBarButtonItem(title: "免费注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.register))
        self.navigationItem.rightBarButtonItem = rightItem
        
        observeKeyboard()
        
        self.view.layer.addSublayer(gradientL)
        
        if WXApi.isWXAppInstalled(){
            initThirdLogin()
        }
        
        initLoginV()
    
        tencentOAuth = TencentOAuth.init(appId: tencentAppid, andDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = kTextColor
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initLoginV(){
        self.view.addSubview(containerV)
        
        containerV.addSubview(aileyunImgV)
        aileyunImgV.snp.updateConstraints { (make) in
            make.left.right.top.equalTo(containerV)
            make.height.equalTo(80)
        }
        aileyunImgV.contentMode = UIViewContentMode.scaleAspectFit
        
        let headL = UILabel()
        containerV.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(aileyunImgV.snp.bottom).offset(40)
        }
        headL.text = "登录名"
        headL.font = UIFont.init(name: kReguleFont, size: 16)
        headL.textColor = kTextColor
        
        containerV.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right).offset(10)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(20)
        }
        cellphoneTF.placeholder = "输入手机号"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 16)
        cellphoneTF.textColor = kTextColor
        cellphoneTF.textAlignment = NSTextAlignment.right
        cellphoneTF.keyboardType = UIKeyboardType.numberPad
        cellphoneTF.clearButtonMode = .whileEditing
        cellphoneTF.text = UserDefaults.standard.value(forKey: kUserPhone) as? String
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(headL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        let passwordL = UILabel()
        containerV.addSubview(passwordL)
        passwordL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(divisionV.snp.bottom).offset(25)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        passwordL.text = "密码"
        passwordL.font = UIFont.init(name: kReguleFont, size: 16)
        passwordL.textColor = kTextColor
        
        containerV.addSubview(passwordTF)
        passwordTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(passwordL)
            make.left.equalTo(passwordL.snp.right).offset(10)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(20)
        }
        passwordTF.font = UIFont.init(name: kReguleFont, size: 16)
        passwordTF.textColor = kTextColor
        passwordTF.placeholder = "请输入密码"
        passwordTF.textAlignment = NSTextAlignment.right
        passwordTF.isSecureTextEntry = true
        passwordTF.clearButtonMode = .whileEditing
        passwordTF.delegate = self
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.top.equalTo(passwordL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        diviV.backgroundColor = kdivisionColor
        
        let findBtn = UIButton()
        containerV.addSubview(findBtn)
        findBtn.snp.updateConstraints { (make) in
            make.top.equalTo(diviV.snp.bottom).offset(15)
            make.right.equalTo(containerV).offset(-40)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        findBtn.setTitle("忘记密码？", for: UIControlState.normal)
        findBtn.setTitleColor(kTextColor, for: UIControlState.normal)
        findBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        
        findBtn.addTarget(self, action: #selector(LoginViewController.findPassword), for: UIControlEvents.touchUpInside)
        
        let loginBtn = UIButton()
        containerV.addSubview(loginBtn)
        loginBtn.snp.updateConstraints { (make) in
            make.top.equalTo(diviV.snp.bottom).offset(50)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(40)
        }
        loginBtn.setTitle("登 录", for: UIControlState.normal)
        loginBtn.layer.cornerRadius = 10
        loginBtn.backgroundColor = kDefaultThemeColor
        
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), for: UIControlEvents.touchUpInside)

        #if DEBUG
        cellphoneTF.text = "18942139158"
        passwordTF.text   = "123456"
        #endif
    }
    
    func initThirdLogin(){
        let space = AppDelegate.shareIntance.space
        
        let containerV = UIView()
        self.view.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-space.bottomSpace)
            make.left.right.equalTo(self.view)
            make.height.equalTo(80)
        }
        
        //QQ
        containerV.addSubview(QQBtn)
        QQBtn.snp.updateConstraints { (make) in
            make.right.equalTo(containerV.snp.centerX).offset(-50)
            make.width.equalTo(90)
            make.bottom.equalTo(containerV).offset(-20)
            make.height.equalTo(30)
        }
        QQBtn.imgv.image = UIImage.init(named: "QQ02")
        QQBtn.titleL.text = "QQ登录"
        
        QQBtn.addTarget(self, action: #selector(LoginViewController.QQLogin), for: UIControlEvents.touchUpInside)
        
        //微信
        containerV.addSubview(weixinBtn)
        weixinBtn.snp.updateConstraints { (make) in
            make.left.equalTo(containerV.snp.centerX).offset(50)
            make.centerY.width.height.equalTo(QQBtn)
        }
        weixinBtn.imgv.image = UIImage.init(named: "微信02")
        weixinBtn.titleL.text = "微信登录"
        
        weixinBtn.addTarget(self, action: #selector(LoginViewController.sendAuthRequest), for: UIControlEvents.touchUpInside)
        
        let infoL = UILabel()
        containerV.addSubview(infoL)
        infoL.snp.updateConstraints { (make) in
            make.centerX.equalTo(containerV)
            make.bottom.equalTo(weixinBtn.snp.top).offset(-10)
            make.width.equalTo(160)
            make.height.equalTo(20)
        }
        infoL.text = "其他登录方式"
        infoL.font = UIFont.init(name: kReguleFont, size: 14)
        infoL.textColor = kLightTextColor
        infoL.textAlignment = NSTextAlignment.center
        
        let leftV = UIView()
        containerV.addSubview(leftV)
        leftV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(infoL.snp.left)
            make.centerY.equalTo(infoL)
            make.height.equalTo(1)
        }
        leftV.backgroundColor = kdivisionColor
        
        let rightV = UIView()
        containerV.addSubview(rightV)
        rightV.snp.updateConstraints { (make) in
            make.left.equalTo(infoL.snp.right)
            make.right.equalTo(containerV).offset(-40)
            make.centerY.equalTo(infoL)
            make.height.equalTo(1)
        }
        rightV.backgroundColor = kdivisionColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let rect = CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 1
        }
    }
    
    func login(){
        
    
        guard cellphoneTF.text != "" && cellphoneTF.text != nil else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard passwordTF.text != "" && passwordTF.text != nil else {
            HCShowError(info: "请输入密码！")
            return
        }

        SVProgressHUD.show()
        UserManager.shareIntance.HC_login(uname: cellphoneTF.text!, pwd: passwordTF.text!) { [weak self](success, msg) in
            if success == true{
                UserDefaults.standard.set(self?.cellphoneTF.text!, forKey: kUserPhone)

                HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                    }else{
                        HCShowError(info: msg)
                    }
                })
            }else{
                HCShowError(info: msg)
            }
        }

        
    }

    func register(){
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    func findPassword(){
        self.navigationController?.pushViewController(findViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //微信
    func sendAuthRequest(){
        let req = SendAuthReq.init()
        //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
        req.scope = "snsapi_userinfo"
        //建议第三方带上该参数，可设置为简单的随机数加session进行校验
        req.state = "123"
        if WXApi.isWXAppInstalled(){
            WXApi.send(req)
        }else{
            WXApi.sendAuthReq(req, viewController: self, delegate: AppDelegate.shareIntance)
        }
    }

    func QQLogin(){
        let permissions = ["add_share", "get_user_info", "get_simple_userinfo"]
        //登录时，调用TencetnOAuth对象的authorize方法
        tencentOAuth?.authorize(permissions)
    }

}


extension LoginViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {   //增加字符的情况
            let t = textField.text ?? ""
            textField.text = t + string
            return false
        }
        return true
    }
    
}

extension LoginViewController : TencentSessionDelegate {
    func tencentDidLogin() {
        if (tencentOAuth!.accessToken != nil) && tencentOAuth?.accessToken.lengthOfBytes(using: String.Encoding.utf8) != 0{
            // 记录登录用户的OpenID、Token以及过期时间
            SVProgressHUD.show()
            tencentOAuth?.getUserInfo()
        }else{
            HCPrint(message: "登录不成功 没有获取accesstoken")
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled == true {
            HCShowError(info: "已取消登录")
        }else{
            HCShowError(info: "登录失败")
        }
    }
    
    func tencentDidNotNetWork() {
        HCShowError(info: "无网络连接！")
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        if (response != nil) && response.retCode == 0 {
            
            // 是否需要绑定手机？
            HttpRequestManager.shareIntance.HC_thirdLogin(accessToken: (tencentOAuth?.accessToken)!, openId: (tencentOAuth?.openId)!, loginType: "qq", appid: tencentAppid, callback: {[weak self](success, code, msg) in
                
                if code == 200 {
                    HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
                        if success == true {
                            SVProgressHUD.dismiss()
                            UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                        }else{
                            HCShowError(info: msg)
                        }
                    })
                }else if code == 201{
                    //绑定手机
                    SVProgressHUD.dismiss()
                    let bindVC = RegisterViewController()
                    bindVC.isBind = true
                    bindVC.bindInfo = ["accessToken" : (self?.tencentOAuth?.accessToken)!, "openId" : (self?.tencentOAuth?.openId)!, "loginType" : "qq", "appId" : tencentAppid]
                    self?.navigationController?.pushViewController(bindVC, animated: true)
                }else{
                    //出错
                    HCShowError(info: msg)
                }
            })
        }else{
            HCShowError(info: "\(response.detailRetCode)")
        }
    }
    
}

extension LoginViewController {
    func observeKeyboard() -> () {
        //注册键盘出现的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardShow() -> () {
        let rect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 400)
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 0
        }
    }
    
}
