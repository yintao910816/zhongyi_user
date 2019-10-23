//
//  SubmitViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class SubmitViewController: BaseViewController {
    var docModel : DoctorModel?{
        didSet{
            price = docModel?.docPrice
            doctorId = docModel?.doctorId
            doctorName = docModel?.realName
        }
    }
    
    var consultId : NSInteger?
    
    var price : String?

    var doctorId : NSNumber?
    
    var doctorName : String?{
        didSet{
            namel.text = doctorName!
        }
    }
    var patientName : String?{
        didSet{
            nameInput.text  = patientName
        }
    }
    var listConsult : String?{
        didSet{
            contentInput.text = listConsult
            contentInput.placeholdL.isHidden = true
        }
    }
    
    var picArr : [UIImage]?
    

    //是否是更改咨询内容
    var isModify : Bool = false
    
    
    lazy var scrollV : UIScrollView = {
        let space = AppDelegate.shareIntance.space
        let s =  UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        return s
    }()
    
    lazy var namel : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 15)
        l.textAlignment = NSTextAlignment.right
        l.textColor = kTextColor
        return l
    }()
    
    lazy var nameInput : UITextField = {
        let f = UITextField()
        f.placeholder = "请输入您的姓名，必填"
        f.textAlignment = NSTextAlignment.right
        f.font = UIFont.init(name: kReguleFont, size: 14)
        f.textColor = kTextColor
        return f
    }()
    
    lazy var ageInput : UITextField = {
        let a = UITextField()
        a.placeholder = "请输入您的年龄，必填"
        a.textAlignment = NSTextAlignment.right
        a.keyboardType = .numberPad
        a.font = UIFont.init(name: kReguleFont, size: 14)
        a.textColor = kTextColor
        return a
    }()
    
    lazy var contentInput : PlaceHolderTextView = {
        let textV = PlaceHolderTextView.init(frame: CGRect.init(x: 20, y: 0, width: SCREEN_WIDTH - 40, height: 80), textContainer: nil)
        textV.font = UIFont.init(name: kReguleFont, size: 14)
        textV.textColor = kTextColor
        textV.placeholdS = "请详细描述您的症状，便于医生更准确的分析。官方app确保您的隐私安全"
        return textV
    }()
    
    lazy var pickPhotoV : PhotoPickerView = {
        let p = PhotoPickerView.init(frame: CGRect.init(x: 20, y: 0, width: SCREEN_WIDTH - 40, height: 80))
        p.picBlock = {[weak self](arr)in
            self?.picArr = arr
        }
        return p
    }()

    let noticeBtn = UIButton.init(frame: CGRect.init(x: 20, y: 5, width: 100, height: 30))
    let submitBtn = UIButton.init(frame: CGRect.init(x: 20, y: 190, width: SCREEN_WIDTH - 40, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientName = UserManager.shareIntance.HCUserInfo?.realname
        self.navigationItem.title = "提交问题"
        
        initUI()
    }
    
    func endEditing(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SubmitViewController {
    func initUI(){
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(SubmitViewController.endEditing))
        self.view.addGestureRecognizer(tapG)
        
        self.view.addSubview(scrollV)
        scrollV.backgroundColor = UIColor.white
        scrollV.contentSize = CGSize.init(width: 0, height: 600)
        
        let nameTitle = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 40, height: 40))
        nameTitle.text = "医生"
        nameTitle.font = UIFont.init(name: kReguleFont, size: 14)
        nameTitle.textColor = kTextColor
        scrollV.addSubview(nameTitle)
        
        scrollV.addSubview(namel)
        namel.snp.updateConstraints { (make) in
            make.left.equalTo(scrollV).offset(SCREEN_WIDTH - 220)
            make.centerY.equalTo(nameTitle)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let diviV1 = UIView()
        scrollV.addSubview(diviV1)
        diviV1.backgroundColor = kdivisionColor
        diviV1.snp.updateConstraints { (make) in
            make.top.equalTo(nameTitle.snp.bottom)
            make.height.equalTo(1)
            make.left.equalTo(scrollV)
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        let nameTitle2 = UILabel()
        nameTitle2.text = "姓名"
        nameTitle2.font = UIFont.init(name: kReguleFont, size: 14)
        nameTitle2.textColor = kTextColor
        scrollV.addSubview(nameTitle2)
        nameTitle2.snp.updateConstraints { (make) in
            make.top.equalTo(diviV1.snp.bottom)
            make.height.equalTo(40)
            make.left.equalTo(nameTitle)
            make.width.equalTo(40)
        }
        
        scrollV.addSubview(nameInput)
        nameInput.snp.updateConstraints { (make) in
            make.left.equalTo(scrollV).offset(SCREEN_WIDTH - 220)
            make.centerY.equalTo(nameTitle2)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let diviV2 = UIView()
        scrollV.addSubview(diviV2)
        diviV2.backgroundColor = kdivisionColor
        diviV2.snp.updateConstraints { (make) in
            make.top.equalTo(nameTitle2.snp.bottom)
            make.height.equalTo(1)
            make.left.equalTo(scrollV)
            make.width.equalTo(SCREEN_WIDTH)
        }

        let ageL = UILabel()
        ageL.text = "年龄"
        ageL.font = UIFont.init(name: kReguleFont, size: 14)
        ageL.textColor = kTextColor
        scrollV.addSubview(ageL)
        ageL.snp.updateConstraints { (make) in
            make.top.equalTo(diviV2.snp.bottom)
            make.height.equalTo(40)
            make.left.equalTo(nameTitle)
            make.width.equalTo(40)
        }
        
        scrollV.addSubview(ageInput)
        ageInput.snp.updateConstraints { (make) in
            make.left.equalTo(scrollV).offset(SCREEN_WIDTH - 220)
            make.centerY.equalTo(ageL)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        let diviV3 = UIView()
        scrollV.addSubview(diviV3)
        diviV3.backgroundColor = kdivisionColor
        diviV3.snp.updateConstraints { (make) in
            make.top.equalTo(ageL.snp.bottom)
            make.height.equalTo(1)
            make.left.equalTo(scrollV)
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        let contentV = UIView()
        scrollV.addSubview(contentV)
        contentV.snp.updateConstraints {(make) in
            make.left.equalTo(scrollV)
            make.top.equalTo(diviV3.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(80)
        }
        
        contentV.addSubview(contentInput)

        
        let containV = UIView()
        scrollV.addSubview(containV)
        containV.snp.updateConstraints { (make) in
            make.top.equalTo(contentV.snp.bottom)
            make.left.equalTo(scrollV)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(80)
        }
        
        containV.addSubview(pickPhotoV)
        
        let containV2 = UIView()
        scrollV.addSubview(containV2)
        containV2.backgroundColor = klightGrayColor
        containV2.snp.updateConstraints { (make) in
            make.top.equalTo(containV.snp.bottom).offset(20)
            make.left.equalTo(scrollV)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(600)
        }
        
        noticeBtn.setTitle("咨询须知", for: UIControlState.normal)
        noticeBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        noticeBtn.setTitleColor(kTextColor, for: UIControlState.normal)
        noticeBtn.setImage(UIImage.init(named: "未选中"), for: UIControlState.normal)
        noticeBtn.setImage(UIImage.init(named: "选中"), for: UIControlState.selected)
        noticeBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        noticeBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -15, bottom: 0, right: 0)
        noticeBtn.isSelected = true
        containV2.addSubview(noticeBtn)
        
        noticeBtn.addTarget(self, action: #selector(SubmitViewController.notice), for: UIControlEvents.touchUpInside)
        
        let s = "1、一问一答，医生本人回复\n2、3天内无人回复，全额退款\n3、医生的建议谨慎参考，对于咨询过程中出现的后果，本APP不承担法律责任\n4、医生提供的是在线咨询服务非医疗行为"
        let attrS = NSMutableAttributedString.init(string: s)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 10
        attrS.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange.init(location: 0, length: s.characters.count))
        
        let noticeL = UILabel.init(frame: CGRect.init(x: 20, y: 35, width: SCREEN_WIDTH - 40, height: 150))
        noticeL.font = UIFont.init(name: kReguleFont, size: 14)
        noticeL.textColor = kTextColor
        noticeL.numberOfLines = 0
        noticeL.attributedText = attrS
        containV2.addSubview(noticeL)
        
        submitBtn.setTitle("提交问题", for: UIControlState.normal)
        submitBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 16)
        submitBtn.backgroundColor = kDefaultThemeColor
        submitBtn.layer.cornerRadius = 5
        containV2.addSubview(submitBtn)
        
        submitBtn.addTarget(self, action: #selector(SubmitViewController.submit), for: UIControlEvents.touchUpInside)
        
    }
    
    func notice(btn : UIButton){
        noticeBtn.isSelected = !btn.isSelected
    
    }
    
    func submit(){
        if noticeBtn.isSelected == false{
            HCShowError(info: "请勾选咨询须知")
        }else if contentInput.text == ""{
            HCShowError(info: "请填写症状描述")
        }else if nameInput.text == ""{
            HCShowError(info: "请填写真实姓名")
        }else if ageInput.text == ""{
            HCShowError(info: "请填写您的年龄")
        }else{
            
            let r = isAge(numb: ageInput.text!)
            guard r.0 == true else {
                HCShowError(info: "输入的年龄不对")
                return
            }
            
            SVProgressHUD.show()
            submitBtn.isEnabled = false
            //上传图片 
            if let picArr = picArr{
                HttpRequestManager.shareIntance.HC_uploadImgs(img: picArr, callback: { [weak self](success, picString) in
                    if success == true {
                        self?.submitConsult(age: r.1, picS: picString)
                    }else{
                        HCShowError(info: "上传图片失败")
                        self?.submitBtn.isEnabled = true
                    }
                })
            }else{
                submitConsult(age: r.1, picS: "")
            }
        }
    }
    
    func submitConsult(age : NSInteger, picS : String){
        
        guard isModify == false else {
            HttpRequestManager.shareIntance.HC_editConsult(consultId: consultId!, content: contentInput.text, imageList: picS, callback: { [weak self](success, msg) in
                if success == true {
                    if self?.price == "免费"{
                        self?.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
                    }else{
                        let payVC = ConfirmOrderViewController()
                        payVC.price = self?.price
                        payVC.doctorName = self?.doctorName
                        payVC.consultId = NSNumber.init(value: (self?.consultId)!)
                        self?.navigationController?.pushViewController(payVC, animated: true)
                    }
                    SVProgressHUD.dismiss()
                }else{
                    HCShowError(info: msg)
                    self?.submitBtn.isEnabled = true
                }
            })
            return
        }
        
        HttpRequestManager.shareIntance.HC_addConsult(content: contentInput.text, doctorId: (doctorId?.intValue)!, realName: nameInput.text!, age: age, imageList: picS, callback: {[weak self](success, model, msg) in
            
            if success == true {
                if self?.price == "免费"{
                    self?.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
                }else{
                    let payVC = ConfirmOrderViewController()
                    payVC.price = self?.price
                    payVC.doctorName = self?.doctorName
                    payVC.consultId = model?.id
                    self?.navigationController?.pushViewController(payVC, animated: true)
                }
                SVProgressHUD.dismiss()
            }else{
                HCShowError(info: msg)
                self?.submitBtn.isEnabled = true
            }
        })

    }
    
    func isAge(numb : String)->(Bool, NSInteger){
        let scanner = Scanner(string: numb)
        var ageNum : Int = 0
        scanner.scanInt(&ageNum)
        if ageNum < 0 || ageNum > 100 {
            return (false, 0)
        }else{
            return (true, ageNum)
        }
    }
}

