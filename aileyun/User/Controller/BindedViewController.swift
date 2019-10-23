//
//  BindedViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class BindedViewController: UIViewController {
    
    lazy var hospitalL : UILabel = {
        let h = UILabel()
        h.font = UIFont.init(name: kReguleFont, size: kTextSize)
        h.textColor = kLightTextColor
        h.textAlignment = NSTextAlignment.right
        return h
    }()
    
    lazy var nameL : UILabel = {
        let n = UILabel()
        n.font = UIFont.init(name: kReguleFont, size: kTextSize)
        n.textColor = kLightTextColor
        n.textAlignment = NSTextAlignment.right
        return n
    }()
    
    lazy var idNumL : UILabel = {
        let n = UILabel()
        n.font = UIFont.init(name: kReguleFont, size: kTextSize)
        n.textColor = kLightTextColor
        n.textAlignment = NSTextAlignment.right
        return n
    }()
    
//    lazy var medNumL : UILabel = {
//        let m = UILabel()
//        m.font = UIFont.init(name: kReguleFont, size: kTextSize)
//        m.textColor = kLightTextColor
//        m.textAlignment = NSTextAlignment.right
//        return m
//    }()
    
    lazy var unbindBtn : UIButton = {
        let b = UIButton()
        b.setTitle("解除绑定", for: UIControlState.normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kDefaultThemeColor
        b.layer.cornerRadius = 5
        b.titleLabel?.font = UIFont.init(name: kReguleFont, size:  15)
        return b
    }()
    
    
    var bindedM : BindedModel? {
        didSet{
            hospitalL.text = bindedM?.hospitalName
//            medNumL.text = bindedM?.visitCard
            nameL.text = bindedM?.realName
            idNumL.text = bindedM?.idNo
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "绑定机构"
        self.view.backgroundColor = kDefaultThemeColor
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        scrollV.backgroundColor = klightGrayColor
        
        //        scrollV.contentSize = CGSize.init(width: 0, height: SCREEN_HEIGHT * 1.2)
        
        self.view.addSubview(scrollV)
        
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 135))
        containV.backgroundColor = UIColor.white
        scrollV.addSubview(containV)
        
        let hosL = UILabel()
        containV.addSubview(hosL)
        hosL.snp.updateConstraints { (make) in
            make.top.left.equalTo(containV).offset(20)
            make.height.equalTo(20)
        }
        hosL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        hosL.textColor = kTextColor
        hosL.text = "生殖中心"
        
        containV.addSubview(hospitalL)
        hospitalL.snp.updateConstraints { (make) in
            make.right.equalTo(containV).offset(-20)
            make.top.equalTo(hosL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        
        let divisionV1 = UIView()
        containV.addSubview(divisionV1)
        divisionV1.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(hosL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV1.backgroundColor = kdivisionColor
        
        
        let realnameL = UILabel()
        containV.addSubview(realnameL)
        realnameL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV1.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        realnameL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        realnameL.textColor = kTextColor
        realnameL.text = "姓名"
        
        containV.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.right.equalTo(hospitalL)
            make.top.equalTo(realnameL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        
        let divisionV2 = UIView()
        containV.addSubview(divisionV2)
        divisionV2.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(realnameL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV2.backgroundColor = kdivisionColor
        
        
        let idNoL = UILabel()
        containV.addSubview(idNoL)
        idNoL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV2.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        idNoL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        idNoL.textColor = kTextColor
        idNoL.text = "身份证"
        
        containV.addSubview(idNumL)
        idNumL.snp.updateConstraints { (make) in
            make.right.equalTo(hospitalL)
            make.top.equalTo(idNoL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        
//        let divisionV3 = UIView()
//        containV.addSubview(divisionV3)
//        divisionV3.snp.updateConstraints { (make) in
//            make.left.equalTo(hosL)
//            make.top.equalTo(idNoL.snp.bottom).offset(10)
//            make.width.equalTo(SCREEN_WIDTH - 40)
//            make.height.equalTo(1)
//        }
//        divisionV3.backgroundColor = kdivisionColor
        
//        let medCardL = UILabel()
//        containV.addSubview(medCardL)
//        medCardL.snp.updateConstraints { (make) in
//            make.left.equalTo(hosL)
//            make.top.equalTo(divisionV3.snp.bottom).offset(10)
//            make.height.equalTo(20)
//        }
//        medCardL.font = UIFont.init(name: kReguleFont, size: kTextSize)
//        medCardL.textColor = kTextColor
//        medCardL.text = "就诊卡"
        
//        containV.addSubview(medNumL)
//        medNumL.snp.updateConstraints { (make) in
//            make.right.equalTo(hospitalL)
//            make.top.equalTo(medCardL)
//            make.height.equalTo(20)
//            make.left.equalTo(hosL.snp.right)
//        }
       
        scrollV.addSubview(unbindBtn)
        unbindBtn.snp.updateConstraints { (make) in
            make.top.equalTo(containV.snp.bottom).offset(20)
            make.left.equalTo(scrollV).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(40)
        }
        
        unbindBtn.addTarget(self, action: #selector(BindedViewController.abandonBind), for: UIControlEvents.touchUpInside)
    }
    
    
    func abandonBind(){
        let alertController = UIAlertController(title: "提醒",
                                                message: "如果不绑定，则无法使用预约挂号、检验报告等核心功能", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action)->() in
        })
        
        let cancelAction = UIAlertAction.init(title: "解除绑定", style: .cancel) { [weak self](action) in
            self?.unbindAction()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func unbindAction(){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_unbind(hospitalId: (bindedM?.hospitalId?.intValue)!, medCard: (bindedM?.visitCard)!, idNo: (bindedM?.idNo)!) {( success, message) in
            if success == true {
                HCShowInfo(info: message)
                self.navigationController?.popViewController(animated: true)
            }else{
                HCShowError(info: message)
            }
        }
    }
}
