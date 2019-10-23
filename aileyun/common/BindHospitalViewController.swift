//
//  BindHospitalViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/2.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

//鼓楼专用
class BindHospitalViewController: UIViewController {
    
    lazy var noticeBtn : UIButton = {
            let b = UIButton()
            b.setTitle("服务条款", for: UIControlState.normal)
            b.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
            b.setTitleColor(kTextColor, for: UIControlState.normal)
            b.setImage(UIImage.init(named: "未选中"), for: UIControlState.normal)
            b.setImage(UIImage.init(named: "选中"), for: UIControlState.selected)
            b.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
            b.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            b.isSelected = true
            return b
        }()
    
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    //固定中一
    func setModel(){
//        let dic = NSDictionary.init(dictionary: ["id" : "17", "name" : "中山一院生殖中心"])
        let dic = NSDictionary.init(dictionary: ["id" : "19", "name" : "鼓楼医院生殖中心"])
        hospitalModel = HospitalListModel.init(dic as! [String : Any])
    }
    
    
    func setData(){
        idNoTextF.text = UserManager.shareIntance.HCUserInfo?.idNo
        medCardTextF.text = UserManager.shareIntance.HCUserInfo?.visitCard
        realnameTextF.text = UserManager.shareIntance.HCUserInfo?.realname
    }
    
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        scrollV.backgroundColor = klightGrayColor
        
//        scrollV.contentSize = CGSize.init(width: 0, height: SCREEN_HEIGHT * 1.2)
    
        self.view.addSubview(scrollV)
        
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180))
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
        realnameTextF.placeholder = "请输入姓名"
        
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
        
        let divisionV3 = UIView()
        containV.addSubview(divisionV3)
        divisionV3.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(idNoL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV3.backgroundColor = kdivisionColor
        
        let medCardL = UILabel()
        containV.addSubview(medCardL)
        medCardL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV3.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        medCardL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        medCardL.textColor = kTextColor
        medCardL.text = "就诊卡"
        
        containV.addSubview(medCardTextF)
        medCardTextF.snp.updateConstraints { (make) in
            make.right.equalTo(hosNameL)
            make.top.equalTo(medCardL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        medCardTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
        medCardTextF.textColor = kTextColor
        medCardTextF.keyboardType = .numberPad
        medCardTextF.textAlignment = NSTextAlignment.right
        medCardTextF.placeholder = "请输入就诊卡号"
        
        
        let imgV = UIImageView.init(image: UIImage.init(named: "medicalRecord.jpg"))
        scrollV.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.top.equalTo(containV.snp.bottom).offset(20)
            make.left.equalTo(scrollV).offset(40)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(SCREEN_WIDTH - 180)
        }
        
        
        let contV = UIView.init()
        scrollV.addSubview(contV)
        contV.snp.updateConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(10)
            make.centerX.equalTo(scrollV)
            make.height.equalTo(30)
        }
        
        contV.addSubview(noticeBtn)
        noticeBtn.snp.updateConstraints { (make) in
            make.left.top.height.equalTo(contV)
            make.width.equalTo(100)
        }
        noticeBtn.addTarget(self, action: #selector(BindHospitalViewController.notice), for: UIControlEvents.touchUpInside)
        
        
        let protocolBtn = UIButton()
        protocolBtn.setTitle("《app使用协议和隐私条款》", for: UIControlState.normal)
        protocolBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        protocolBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        
        contV.addSubview(protocolBtn)
        protocolBtn.snp.updateConstraints { (make) in
            make.left.equalTo(noticeBtn.snp.right)
            make.top.height.equalTo(noticeBtn)
            make.right.equalTo(contV)
        }
        
        protocolBtn.addTarget(self, action: #selector(BindHospitalViewController.protocolWebview), for: .touchUpInside)
        
        
        let bindBtn = UIButton()
        scrollV.addSubview(bindBtn)
        bindBtn.snp.updateConstraints { (make) in
            make.top.equalTo(contV.snp.bottom).offset(20)
            make.left.equalTo(hosL)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(40)
        }
        bindBtn.layer.cornerRadius = 5
        bindBtn.backgroundColor = kDefaultThemeColor
        bindBtn.setTitle("绑定", for: UIControlState.normal)
        bindBtn.addTarget(self, action: #selector(BindHospitalViewController.bindHospital), for: UIControlEvents.touchUpInside)
    }
    
    
    func protocolWebview(){
        let webV = WebViewController()
        //        webV.url = "http://www.ivfcn.com/static/html/aileyunInfo.html"
        webV.url = "http://www.ivfcn.com/static/html/gulouInfo.html"
        //        webV.url = "http://www.ivfcn.com/static/html/zhongyiInfo.html"
        self.navigationController?.pushViewController(webV, animated: true)
    }
    
    func notice(btn : UIButton){
        noticeBtn.isSelected = !btn.isSelected
    }
    
    
    func hospitalList(){
        //中一不需要跳转列表
        self.view.endEditing(true)
        
//        let hospVC = HospitalListViewController()
//        hospVC.chooseBlock = {[weak self](model)in
//            self?.hospitalModel = model
//        }
//        if let arr = hospitalArr {
//            hospVC.hospitalArr = arr
//        }
//        self.navigationController?.pushViewController(hospVC, animated: true)
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
    
    func bindHospital(){
        guard hospitalModel != nil else {
            HCShowError(info: "请选择生殖中心！")
            return
        }
        
        guard idNoTextF.text != "" && idNoTextF.text != nil else {
            HCShowError(info: "请输入身份证！")
            return
        }
        
        guard medCardTextF.text != "" && medCardTextF.text != nil else {
            HCShowError(info: "请输入就诊卡号！")
            return
        }
        
        guard realnameTextF.text != "" && realnameTextF.text != nil else {
            HCShowError(info: "请输入真实姓名！")
            return
        }
        
        guard noticeBtn.isSelected == true else {
            HCShowError(info: "请勾选使用协议")
            return
        }
        
        let hosId = (hospitalModel?.id)!
        let medS = medCardTextF.text!
        let idS = idNoTextF.text!
        let userS = realnameTextF.text!
        
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_bindCard(hospitalId: Int(hosId)!, medCard: medS, idNo: idS, userName: userS) {(success, message) in
            if success == true {
                self.navigationController?.popViewController(animated: true)
                HCShowInfo(info: "绑定成功！")
            }else{
                HCShowError(info: message)
            }
        }

        
    }

    func abandonBind(){
        
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

}
