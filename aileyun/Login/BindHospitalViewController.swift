//
//  BindHospitalViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/2.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import HandyJSON

class BindHospitalViewController: UIViewController {
    
    var hospitalModel : HospitalListModel?{
        didSet{
            hosNameL.text = hospitalModel?.name
        }
    }
    
    var hospitalArr : [HospitalListModel]?{
        didSet{
            hospitalModel = hospitalArr?[0]
        }
    }
    
    let hosNameL = UILabel()
    let idNoTextF = UITextField()
    let medCardTextF = UITextField()
    
    let realnameTextF = UITextField()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.title = "绑定机构"
        self.view.backgroundColor = kDefaultThemeColor
        
        initUI()
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(BindHospitalViewController.hospitalList))
        hosNameL.addGestureRecognizer(tapG)
        
        //不需要定位请求医院列表
        setModel()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(BindHospitalViewController.requestData), name: NSNotification.Name.init(LOCATION_AUTH), object: nil)
//
//        HCLocationManager.shareInstance.requestAuthorization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    //固定中一
    func setModel(){
        let dic = NSDictionary.init(dictionary: ["id" : "17", "name" : "中山一院生殖中心"])
//        let dic = NSDictionary.init(dictionary: ["id" : "19", "name" : "鼓楼医院生殖中心"])
//        hospitalModel = HospitalListModel.init(dic as! [String : Any])
        hospitalModel = JSONDeserializer<HospitalListModel>.deserializeFrom(dict: dic)
    }
    
    func setData(){
        idNoTextF.text = UserManager.shareIntance.HCUserInfo?.idNo
//        medCardTextF.text = UserManager.shareIntance.HCUserInfo?.visitCard
        realnameTextF.text = UserManager.shareIntance.HCUserInfo?.realname
    }
    
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        scrollV.backgroundColor = klightGrayColor
        
        scrollV.contentSize = CGSize.init(width: 0, height: SCREEN_HEIGHT * 1.2)
    
        self.view.addSubview(scrollV)
        
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 135))
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
        
        containV.addSubview(hosNameL)
        hosNameL.snp.updateConstraints { (make) in
            make.right.equalTo(containV).offset(-20)
            make.top.equalTo(hosL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        hosNameL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        hosNameL.textColor = kLightTextColor
        hosNameL.textAlignment = NSTextAlignment.right
        hosNameL.isUserInteractionEnabled = true
        hosNameL.text = "请选择生殖中心"
        
        let divisionV1 = UIView()
        containV.addSubview(divisionV1)
        divisionV1.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(hosL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV1.backgroundColor = kdivisionColor
        
        let idNoL = UILabel()
        containV.addSubview(idNoL)
        idNoL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV1.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        idNoL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        idNoL.textColor = kTextColor
        idNoL.text = "身份证号"
        
        containV.addSubview(idNoTextF)
        idNoTextF.snp.updateConstraints { (make) in
            make.right.equalTo(hosNameL)
            make.top.equalTo(idNoL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        idNoTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
        idNoTextF.textColor = kTextColor
        idNoTextF.textAlignment = NSTextAlignment.right
        idNoTextF.placeholder = "请输入身份证号码"
        
        let divisionV2 = UIView()
        containV.addSubview(divisionV2)
        divisionV2.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(idNoL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV2.backgroundColor = kdivisionColor
        
//        let medCardL = UILabel()
//        containV.addSubview(medCardL)
//        medCardL.snp.updateConstraints { (make) in
//            make.left.equalTo(hosL)
//            make.top.equalTo(divisionV2.snp.bottom).offset(10)
//            make.height.equalTo(20)
//        }
//        medCardL.font = UIFont.init(name: kReguleFont, size: kTextSize)
//        medCardL.textColor = kTextColor
//        medCardL.text = "就诊卡号"
//
//        containV.addSubview(medCardTextF)
//        medCardTextF.snp.updateConstraints { (make) in
//            make.right.equalTo(hosNameL)
//            make.top.equalTo(medCardL)
//            make.height.equalTo(20)
//            make.left.equalTo(hosL.snp.right)
//        }
//        medCardTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
//        medCardTextF.textColor = kTextColor
//        medCardTextF.keyboardType = .numberPad
//        medCardTextF.textAlignment = NSTextAlignment.right
//        medCardTextF.placeholder = "请输入就诊卡号"
        
//        let divisionV3 = UIView()
//        containV.addSubview(divisionV3)
//        divisionV3.snp.updateConstraints { (make) in
//            make.left.equalTo(hosL)
//            make.top.equalTo(medCardL.snp.bottom).offset(10)
//            make.width.equalTo(SCREEN_WIDTH - 40)
//            make.height.equalTo(1)
//        }
//        divisionV3.backgroundColor = kdivisionColor
        
        let realnameL = UILabel()
        containV.addSubview(realnameL)
        realnameL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV2.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        realnameL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        realnameL.textColor = kTextColor
        realnameL.text = "真实姓名"
        
        containV.addSubview(realnameTextF)
        realnameTextF.snp.updateConstraints { (make) in
            make.right.equalTo(hosNameL)
            make.top.equalTo(realnameL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        realnameTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
        realnameTextF.textColor = kTextColor
        realnameTextF.textAlignment = NSTextAlignment.right
        realnameTextF.placeholder = "请输入真实姓名"
        
        
        let bindBtn = UIButton()
        scrollV.addSubview(bindBtn)
        bindBtn.snp.updateConstraints { (make) in
            make.top.equalTo(containV.snp.bottom).offset(20)
            make.left.equalTo(hosL)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(40)
        }
        bindBtn.layer.cornerRadius = 5
        bindBtn.backgroundColor = kDefaultThemeColor
        bindBtn.setTitle("绑定", for: .normal)
        bindBtn.addTarget(self, action: #selector(BindHospitalViewController.bindHospital), for: .touchUpInside)

        let abandonBtn = UIButton()
        scrollV.addSubview(abandonBtn)
        abandonBtn.snp.updateConstraints { (make) in
            make.top.equalTo(bindBtn.snp.bottom).offset(20)
            make.left.equalTo(hosL)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(40)
        }
        abandonBtn.layer.cornerRadius = 5
        abandonBtn.layer.borderColor = kLightTextColor.cgColor
        abandonBtn.layer.borderWidth = 1
        abandonBtn.setTitle("暂不绑定", for: .normal)
        abandonBtn.setTitleColor(kLightTextColor, for: .normal)
        
        abandonBtn.addTarget(self, action: #selector(BindHospitalViewController.abandonBind), for: .touchUpInside)
        
        let attentionL = UILabel()
        
        attentionL.numberOfLines = 0
        attentionL.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        attentionL.textColor = kLightTextColor
        
        let attStr = NSMutableAttributedString.init(string: "注意事项：\n1、此处绑定的就诊卡，属于当前您选择的就诊医院。\n2、此处绑定的就诊卡，必须已经在医院办证窗口登记注册。\n3、每张就诊卡仅限绑定一名用户，请妥善保管自己的就诊卡。\n4、请填写您的真实姓名，我们绝不会泄露您的个人资料。")
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineSpacing = 3
        paraStyle.paragraphSpacing = 3
        paraStyle.headIndent = 20
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraStyle, range: NSRange.init(location: 0, length: attStr.length))
        
        attentionL.attributedText = attStr
        attentionL.sizeToFit()
        
        scrollV.addSubview(attentionL)
        attentionL.snp.updateConstraints { (make) in
            make.top.equalTo(abandonBtn.snp.bottom).offset(30)
            make.left.equalTo(hosL)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
    }
    
    
    @objc func hospitalList(){
//        self.view.endEditing(true)
        
        //中一不需要跳转列表
        let hospVC = HospitalListViewController()
        hospVC.chooseBlock = {[weak self](model)in
            self?.hospitalModel = model
        }
        if let arr = hospitalArr {
            hospVC.hospitalArr = arr
        }
        self.navigationController?.pushViewController(hospVC, animated: true)
    }
    
    func requestData(){
        
        SVProgressHUD.show()
        guard HCLocationManager.shareInstance.checkAuthorization() == true else{
            let lng = 114.268465
            let lat = 30.588937
            HttpRequestManager.shareIntance.HC_getHospitalList(lng: lng, lat: lat, callback: { [weak self](success, arr) in
                SVProgressHUD.dismiss()
                if success == true{
                    self?.hospitalArr = arr
                }else{
                    HCShowError(info: "网络错误")
                }
            })
            return
        }

        HCLocationManager.shareInstance.getCurrentLocation(isOnce: true) { (loc, msg) in
            if loc != nil {
                let lng = loc?.coordinate.longitude
                let lat = loc?.coordinate.latitude
                HttpRequestManager.shareIntance.HC_getHospitalList(lng: lng, lat: lat, callback: { [weak self](success, arr) in
                    SVProgressHUD.dismiss()
                    if success == true{
                        self?.hospitalArr = arr
                    }else{
                        HCShowError(info: "网络错误")
                    }
                })
            }else{
                let lng = 114.268465
                let lat = 30.588937
                HttpRequestManager.shareIntance.HC_getHospitalList(lng: lng, lat: lat, callback: { [weak self](success, arr) in
                    SVProgressHUD.dismiss()
                    if success == true{
                        self?.hospitalArr = arr
                    }else{
                        HCShowError(info: "网络错误")
                    }
                })
            }
        }
    }
    
    @objc func bindHospital(){
        guard hospitalModel != nil else {
            HCShowError(info: "请选择生殖中心！")
            return
        }
        
        guard idNoTextF.text != "" && idNoTextF.text != nil else {
            HCShowError(info: "请输入身份证！")
            return
        }
        
//        guard medCardTextF.text != "" && medCardTextF.text != nil else {
//            HCShowError(info: "请输入就诊卡号！")
//            return
//        }
        
        guard realnameTextF.text != "" && realnameTextF.text != nil else {
            HCShowError(info: "请输入真实姓名！")
            return
        }
        
        let hosId = (hospitalModel?.id)!
//        let medS = medCardTextF.text!
        let medS = "JAKLNKLN13"
        let idS = idNoTextF.text!
        let userS = realnameTextF.text!
        
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_bindCard(hospitalId: Int(hosId)!, medCard: medS, idNo: idS, userName: userS) {(success, message) in
            if success == true {
                self.navigationController?.popViewController(animated: true)
                
                var dic = UserDefaults.standard.value(forKey: kUserDic) as! [String : Any]
                dic["hospitalId"] = NSNumber.init(value: Int(hosId)!)
                UserDefaults.standard.set(dic, forKey: kUserDic)
                
                let not = Notification.init(name: NSNotification.Name.init(BIND_SUCCESS), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
                
                HCShowInfo(info: "绑定成功！")
            }else{
                HCShowError(info: message)
            }
        }

        
    }

    @objc func abandonBind(){
        
        let alertController = UIAlertController(title: "提醒",
                                                message: "如果不绑定，则无法使用预约挂号、检验报告等核心功能", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action)->() in
            
        })
        
        let cancelAction = UIAlertAction.init(title: "暂不绑定", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
