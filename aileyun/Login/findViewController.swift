//
//  findViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class findViewController: UIViewController {
    let cellphoneTF = UITextField()
    let verifyTF = UITextField()
    let passwordTF = UITextField()
    
    let verifyBtn = UIButton()
    
    let seeBtn = UIButton()
    
    var count = 0
    let KMaxSeconds = 120
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "找回密码"
        
        initFindPasswordV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func initFindPasswordV(){
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
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        verifyBtn.backgroundColor = kDefaultThemeColor
        verifyBtn.layer.cornerRadius = 5
        
        verifyBtn.addTarget(self, action: #selector(findViewController.startCount), for: UIControlEvents.touchUpInside)
        
        
        containerV.addSubview(verifyTF)
        verifyTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(verifyL)
            make.left.equalTo(verifyL.snp.right)
            make.right.equalTo(verifyBtn.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        verifyTF.placeholder = "输入验证码"
        verifyTF.font = UIFont.init(name: kReguleFont, size: 14)
        verifyTF.textColor = kTextColor
        verifyTF.textAlignment = NSTextAlignment.right
        
        
        let diviV1 = UIView()
        containerV.addSubview(diviV1)
        diviV1.snp.updateConstraints { (make) in
            make.top.equalTo(verifyL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        diviV1.backgroundColor = kdivisionColor
        
        
        let passwordL = UILabel()
        containerV.addSubview(passwordL)
        passwordL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(diviV1.snp.bottom).offset(25)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        passwordL.text = "新密码"
        passwordL.font = UIFont.init(name: kReguleFont, size: 14)
        passwordL.textColor = kTextColor
        
        let seeBtn = UIButton()
        containerV.addSubview(seeBtn)
        seeBtn.snp.updateConstraints { (make) in
            make.right.equalTo(containerV).offset(-40)
            make.centerY.equalTo(passwordL)
            make.width.height.equalTo(30)
        }
        seeBtn.setImage(UIImage.init(named: "显示"), for: UIControlState.normal)
        
        seeBtn.addTarget(self, action: #selector(findViewController.passwordStyle), for: UIControlEvents.touchUpInside)
        
        
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
        
        
        let resetPasswordBtn = UIButton()
        containerV.addSubview(resetPasswordBtn)
        resetPasswordBtn.snp.updateConstraints { (make) in
            make.top.equalTo(diviV.snp.bottom).offset(50)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(40)
        }
        resetPasswordBtn.setTitle("重置密码", for: UIControlState.normal)
        resetPasswordBtn.layer.cornerRadius = 10
        resetPasswordBtn.backgroundColor = kDefaultThemeColor
        
        resetPasswordBtn.addTarget(self, action: #selector(findViewController.resetPassword), for: UIControlEvents.touchUpInside)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startCount(){
        guard checkIsPhone(cellphoneTF.text!) else{
            HCShowError(info: "请输入正确的手机号码！")
            return
        }
        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.HC_validateCode(phone: cellphoneTF.text!, callback: { [weak self](success, message) in
            SVProgressHUD.dismiss()
            if success {
                HCShowInfo(info: "获取验证码成功！")
                self?.count = 0
                
                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewController.showSecond), userInfo: nil, repeats: true)
            }else{
                SVProgressHUD.showError(withStatus: message)
            }
        })
    }
    
    func showSecond(){
        count = count + 1
        if count == KMaxSeconds {
            resetCodeBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新获取", KMaxSeconds - count)
            verifyBtn.isEnabled = false
            verifyBtn.setTitle(showString, for: UIControlState.normal)
            verifyBtn.backgroundColor = kLightTextColor
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func resetCodeBtn(){
        verifyBtn.isEnabled = true
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.backgroundColor = kDefaultThemeColor
    }
    
    func passwordStyle(){
        passwordTF.isSecureTextEntry = passwordTF.isSecureTextEntry ? false : true
        if passwordTF.isSecureTextEntry {
            seeBtn.setImage(UIImage.init(named: "隐藏"), for: UIControlState.normal)
        }else{
            seeBtn.setImage(UIImage.init(named: "显示"), for: UIControlState.normal)
        }
    }
    
    func resetPassword(){
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
        HttpRequestManager.shareIntance.HC_findPwd(phone: cellphoneTF.text!, pwd: passwordTF.text!, code: verifyTF.text!) { (success, msg) in
            if success == true{
                self.navigationController?.popViewController(animated: true)
                HCShowInfo(info: "密码已设置")
            }else{
                HCShowError(info: msg)
            }
        }

    }

}
