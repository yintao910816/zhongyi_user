//
//  RegisterViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/3.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    var isBind : Bool = false
    var bindInfo : [String : Any]?
    
    let cellphoneTF = UITextField()
    let verifyBtn = UIButton()
    let verifyTF = UITextField()
    
    let seeBtn = UIButton()
    let passwordTF = UITextField()
    
    let registerBtn = UIButton()
    
    let protocolBtn = UIButton()
    
    var count = 0
    let KMaxSeconds = 180
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        initRegisterV()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        NetworkStatusTool.NetworkingStatus()
    }
    
    func initRegisterV(){
        let containerV = UIView()
        self.view.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.top.equalTo(self.view).offset(120)
            make.left.right.equalTo(self.view)
            make.height.equalTo(400)
        }
        
        let headL = UILabel()
        containerV.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(containerV)
        }
        headL.text = "手机号"
        headL.font = UIFont.init(name: kReguleFont, size: 14)
        headL.textColor = kTextColor
        
        containerV.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(20)
        }
        cellphoneTF.placeholder = "输入手机号"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 14)
        cellphoneTF.textColor = kTextColor
        cellphoneTF.textAlignment = NSTextAlignment.right
        cellphoneTF.keyboardType = UIKeyboardType.numberPad
        cellphoneTF.delegate = self
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(headL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        //验证码
        let verifyL = UILabel()
        containerV.addSubview(verifyL)
        verifyL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(divisionV.snp.bottom).offset(25)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        verifyL.text = "验证码"
        verifyL.font = UIFont.init(name: kReguleFont, size: 14)
        verifyL.textColor = kTextColor
        
    
        containerV.addSubview(verifyBtn)
        verifyBtn.snp.updateConstraints { (make) in
            make.right.equalTo(containerV).offset(-40)
            make.centerY.equalTo(verifyL)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        verifyBtn.setTitle("获取验证码", for: .normal)
        verifyBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        verifyBtn.backgroundColor = kDefaultThemeColor
        verifyBtn.layer.cornerRadius = 5
        
        verifyBtn.addTarget(self, action: #selector(RegisterViewController.startCount), for: .touchUpInside)
        
        
        containerV.addSubview(verifyTF)
        verifyTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(verifyL)
            make.left.equalTo(verifyL.snp.right)
            make.right.equalTo(verifyBtn.snp.left).offset(-8)
            make.height.equalTo(20)
        }
        verifyTF.placeholder = "输入验证码"
        verifyTF.font = UIFont.init(name: kReguleFont, size: 14)
        verifyTF.textColor = kTextColor
        verifyTF.keyboardType = UIKeyboardType.numberPad
        verifyTF.textAlignment = NSTextAlignment.right
        verifyTF.delegate = self
        
        
        let diviV1 = UIView()
        containerV.addSubview(diviV1)
        diviV1.snp.updateConstraints { (make) in
            make.top.equalTo(verifyL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        diviV1.backgroundColor = kdivisionColor
        
        containerV.addSubview(registerBtn)
        registerBtn.layer.cornerRadius = 10
        registerBtn.backgroundColor = kDefaultThemeColor
        
        if isBind == false {
            self.navigationItem.title = "注册"
            
            let passwordL = UILabel()
            containerV.addSubview(passwordL)
            passwordL.snp.updateConstraints { (make) in
                make.left.equalTo(containerV).offset(40)
                make.top.equalTo(diviV1.snp.bottom).offset(25)
                make.width.equalTo(60)
                make.height.equalTo(20)
            }
            passwordL.text = "密码"
            passwordL.font = UIFont.init(name: kReguleFont, size: 14)
            passwordL.textColor = kTextColor
            
            
            containerV.addSubview(seeBtn)
            seeBtn.snp.updateConstraints { (make) in
                make.right.equalTo(containerV).offset(-40)
                make.centerY.equalTo(passwordL)
                make.width.height.equalTo(30)
            }
            seeBtn.setImage(UIImage.init(named: "显示"), for: .normal)
            
            seeBtn.addTarget(self, action: #selector(RegisterViewController.passwordStyle), for: .touchUpInside)
            
            
            containerV.addSubview(passwordTF)
            passwordTF.snp.updateConstraints { (make) in
                make.centerY.equalTo(passwordL)
                make.left.equalTo(passwordL.snp.right)
                make.right.equalTo(seeBtn.snp.left).offset(-5)
                make.height.equalTo(20)
            }
            passwordTF.placeholder = "6-16位字母、数字"
            passwordTF.font = UIFont.init(name: kReguleFont, size: 14)
            passwordTF.textColor = kTextColor
            passwordTF.textAlignment = NSTextAlignment.right
            
            
            let diviV = UIView()
            containerV.addSubview(diviV)
            diviV.snp.updateConstraints { (make) in
                make.top.equalTo(passwordL.snp.bottom).offset(10)
                make.left.equalTo(containerV).offset(40)
                make.right.equalTo(containerV).offset(-40)
                make.height.equalTo(1)
            }
            diviV.backgroundColor = kdivisionColor
            
            
            registerBtn.snp.updateConstraints { (make) in
                make.top.equalTo(diviV.snp.bottom).offset(50)
                make.left.equalTo(containerV).offset(40)
                make.right.equalTo(containerV).offset(-40)
                make.height.equalTo(40)
            }
            registerBtn.setTitle("注册 开始体验", for: .normal)
            registerBtn.addTarget(self, action: #selector(RegisterViewController.register), for: .touchUpInside)
            
            containerV.addSubview(protocolBtn)
            protocolBtn.snp.updateConstraints { (make) in
                make.top.equalTo(registerBtn.snp.bottom).offset(30)
                make.centerX.equalTo(containerV)
                make.width.equalTo(300)
                make.height.equalTo(20)
            }
            protocolBtn.setTitle("注册代表您同意《app使用协议和隐私条款》", for: .normal)
            protocolBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
            protocolBtn.setTitleColor(kLightTextColor, for: .normal)
            
            protocolBtn.addTarget(self, action: #selector(RegisterViewController.protocolWebview), for: .touchUpInside)
            
            let highlightV = UIView()
            containerV.addSubview(highlightV)
            highlightV.snp.updateConstraints { (make) in
                make.top.equalTo(protocolBtn.snp.bottom)
                make.centerX.equalTo(containerV).offset(45)
                make.width.equalTo(160)
                make.height.equalTo(1)
            }
            highlightV.backgroundColor = kLightTextColor

        }else{
            self.navigationItem.title = "绑定手机"
            
            registerBtn.snp.updateConstraints { (make) in
                make.top.equalTo(diviV1.snp.bottom).offset(50)
                make.left.equalTo(containerV).offset(40)
                make.right.equalTo(containerV).offset(-40)
                make.height.equalTo(40)
            }
            registerBtn.setTitle("完成绑定 开始体验", for: .normal)
            registerBtn.addTarget(self, action: #selector(RegisterViewController.bind), for: .touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func startCount(){
        guard checkIsPhone(cellphoneTF.text!) else{
            HCShowError(info: "请输入正确的手机号码！")
            return
        }
        
        verifyBtn.isEnabled = false
        
        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.HC_validateCode(phone: cellphoneTF.text!, callback: { [weak self](success, message) in
            guard let strongSelf = self else { return }
            SVProgressHUD.dismiss()
            if success {
                HCShowInfo(info: "获取验证码成功！")
                strongSelf.count = 0

                strongSelf.timer = Timer.scheduledTimer(timeInterval: 1, target: strongSelf, selector: #selector(RegisterViewController.showSecond), userInfo: nil, repeats: true)
            }else{
                HCShowError(info: message)
                self?.verifyBtn.isEnabled = true
            }
        })
    }
    
    @objc func showSecond(){
        count = count + 1
        if count == KMaxSeconds {
            resetCodeBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新获取", KMaxSeconds - count)
            verifyBtn.setTitle(showString, for: .normal)
            verifyBtn.backgroundColor = kLightTextColor
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func resetCodeBtn(){
        verifyBtn.isEnabled = true
        verifyBtn.setTitle("获取验证码", for: .normal)
        verifyBtn.backgroundColor = kDefaultThemeColor
    }
    
    @objc func passwordStyle(){
        passwordTF.isSecureTextEntry = passwordTF.isSecureTextEntry ? false : true
        if passwordTF.isSecureTextEntry {
            HCPrint(message: "隐藏")
            seeBtn.setImage(UIImage.init(named: "隐藏"), for: .normal)
        }else{
            HCPrint(message: "显示")
            seeBtn.setImage(UIImage.init(named: "显示"), for: .normal)
        }
    }
    
    @objc func register(){
        guard cellphoneTF.text != "" else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard verifyTF.text != "" else {
            HCShowError(info: "请输入验证码")
            return
        }
        guard passwordTF.text != "" else {
            HCShowError(info: "请输入密码！")
            return
        }
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_register(uname: cellphoneTF.text!, code: verifyTF.text!, pwd: passwordTF.text!, pwd2: passwordTF.text!) { (success, msg) in
            if success == true{
                //获取userInfo
                HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, message) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        //去首页
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                    }else{
                        HCShowError(info: message)
                    }
                })
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    @objc func bind(){
        guard cellphoneTF.text != "" else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard verifyTF.text != "" else {
            HCShowError(info: "请输入验证码")
            return
        }
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_bindPhone(accessToken: bindInfo?["accessToken"] as! String, openId: bindInfo?["openId"] as! String, code: verifyTF.text!, phone: cellphoneTF.text!, loginType: bindInfo?["loginType"] as! String, appId: bindInfo?["appId"] as! String) {(success, message) in
            if success == true{
                //获取userInfo
                HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, message) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        //去首页
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                    }else{
                        HCShowError(info: message)
                    }
                })
            }else{
                HCShowError(info: message)
            }
        }
        
    }
    
    
    @objc func protocolWebview(){
        let webV = WebViewController()
//        webV.url = "http://www.ivfcn.com/static/html/aileyunInfo.html"
//        webV.url = "http://www.ivfcn.com/static/html/gulouInfo.html"
        webV.url = "http://www.ivfcn.com/static/html/zhongyiInfo.html"
        self.navigationController?.pushViewController(webV, animated: true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    //限制输入字符数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let tempText = textField.text as NSString?
        let tempString = string as NSString
        let newLength = (tempText?.length)! + tempString.length - range.length
        
        if cellphoneTF == textField {
            return newLength <= 11
        }else if verifyTF == textField{
            return newLength <= 6
        }else{
            return true
        }
    }
}
