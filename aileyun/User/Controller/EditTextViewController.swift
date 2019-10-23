//
//  EditTextViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ModifyItemName
{
    case HeadImg
    case Nickname
    case Sex
    case Birthday
    case Sign
}

class EditTextViewController: BaseViewController {
    var modifyType : ModifyItemName = .Nickname{
        didSet{
            HCPrint(message: modifyType)
            switch modifyType {
            case .HeadImg:
                if let imgS = UserManager.shareIntance.HCUserInfo?.imgUrl {
                    headImgV.HC_setImageFromURL(urlS: imgS, placeHolder: "默认头像")
                }else{
                    headImgV.image = UIImage.init(named: "默认头像")
                }
                
                inputF.isHidden = true
                selectImg()
            case .Nickname:
                headImgV.isHidden = true
                inputF.becomeFirstResponder()
            case .Sex:
                inputF.inputView = sexPicker
                headImgV.isHidden = true
                inputF.becomeFirstResponder()
            case .Birthday:
                inputF.inputView = datePicker
                headImgV.isHidden = true
                inputF.becomeFirstResponder()
            case .Sign:
                headImgV.isHidden = true
                inputF.becomeFirstResponder()
            default:
                inputF.inputView = nil
            }
        }
    }
    
    var userInfoM : HCUserInfoModel?
    
    var chooseImg = false
    
    var selectedImg = UIImage() {
        didSet{
            headImgV.image = selectedImg
            chooseImg = true
        }
    }
    
    lazy var sexArr = ["男", "女"]
    
    lazy var inputF : UITextField = {
        let f = UITextField.init(frame: CGRect.init(x: 20, y: 100, width: SCREEN_WIDTH - 40, height: 44))
        f.placeholder = "请输入"
        f.layer.cornerRadius = 5
        f.clearButtonMode = .whileEditing
        f.backgroundColor = UIColor.white
        f.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(f)
        return f
    }()
    
    
    lazy var headImgV : UIImageView = {
        let h = UIImageView.init(frame: CGRect.init(x: 80, y: 100, width: SCREEN_WIDTH - 160, height: SCREEN_WIDTH - 160))
        h.layer.cornerRadius = 5
        h.clipsToBounds = true
        h.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(h)
        return h
    }()
    
    lazy var datePicker : UIDatePicker = {
        let picker = UIDatePicker.init()
        picker.datePickerMode = UIDatePickerMode.date
        let local = Locale.init(identifier: "zh")
        picker.locale = local
        picker.addTarget(self, action: #selector(EditTextViewController.dateChange), for: UIControlEvents.valueChanged)
        return picker
    }()
    
    lazy var sexPicker : UIPickerView = {
        let s = UIPickerView.init()
        s.delegate = self
        s.dataSource = self
        return s
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "修改资料"
        
        userInfoM = UserManager.shareIntance.HCUserInfo
        
        let rightItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(EditTextViewController.confirm))
        self.navigationItem.rightBarButtonItem = rightItem
        
        let space = AppDelegate.shareIntance.space
        let backV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        backV.backgroundColor = klightGrayColor
        self.view.addSubview(backV)
    }
    
    func selectImg(){
        let contV = UIView()
        self.view.addSubview(contV)
        contV.snp.updateConstraints { (make) in
            make.top.equalTo(headImgV.snp.bottom).offset(40)
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        let picBtn = UIButton()
        picBtn.tag = 0
        picBtn.setTitle("相册", for: UIControlState.normal)
        picBtn.backgroundColor = kDefaultThemeColor
        picBtn.layer.cornerRadius = 5
        contV.addSubview(picBtn)
        picBtn.snp.updateConstraints {(make) in
            make.left.equalTo(contV).offset(40)
            make.top.equalTo(contV)
            make.height.equalTo(44)
        }
        picBtn.addTarget(self, action: #selector(EditTextViewController.selectFromSystem), for: .touchUpInside)
        
        let photoBtn = UIButton()
        photoBtn.tag = 1
        photoBtn.setTitle("拍照", for: UIControlState.normal)
        photoBtn.backgroundColor = kDefaultThemeColor
        photoBtn.layer.cornerRadius = 5
        contV.addSubview(photoBtn)
        photoBtn.snp.updateConstraints {(make) in
            make.top.equalTo(contV)
            make.right.equalTo(contV).offset(-40)
            make.height.width.equalTo(picBtn)
            make.left.equalTo(picBtn.snp.right).offset(20)
        }
        photoBtn.addTarget(self, action: #selector(EditTextViewController.selectFromSystem), for: .touchUpInside)
    }
    
    func selectFromSystem(sender : UIButton){
        if sender.tag == 0 {
            systemPic()
        }else{
            takePhoto()
        }
    }
    
    func dateChange(){
        let fmt = DateFormatter.init()
        fmt.dateFormat = "yyyy-MM-dd"
        let s = fmt.string(from: datePicker.date)
        inputF.text = s
    }
    
    
    func confirm(){
        guard inputF.text != "" || chooseImg == true else{
            HCShowError(info: "没有修改任何资料")
            return
        }
        
        //防止多次点击
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let patientId = (UserManager.shareIntance.HCUser?.id?.intValue)!
        
        var dic : NSDictionary!
        
        let nickName = userInfoM?.nickname ?? ""
        let sex = userInfoM?.sex?.intValue ?? 0
        let imgUrl = userInfoM?.imgUrl ?? ""
        let userSign = userInfoM?.userSign ?? ""
        let birthDay = userInfoM?.birthday ?? ""
        
        switch modifyType {
        case .HeadImg:
            updateUserImg(patientId: patientId, nickName: nickName, sex: sex, userSign: userSign, birthDay: birthDay)
        case .Nickname:
            dic = NSDictionary.init(dictionary: ["patientId" : patientId, "nickName" : inputF.text!, "sex" : sex, "imgUrl" : imgUrl, "userSign" : userSign, "birthDay" : birthDay])
            updateUserInfo(dic: dic)
        case .Sex:
            let s = inputF.text == "女" ? "1" : "2"
            dic = NSDictionary.init(dictionary: ["patientId" : patientId, "nickName" : nickName, "sex" : s, "imgUrl" : imgUrl, "userSign" : userSign, "birthDay" : birthDay])
            updateUserInfo(dic: dic)
        case .Sign:
            dic = NSDictionary.init(dictionary: ["patientId" : patientId, "nickName" : nickName, "sex" : sex, "imgUrl" : imgUrl, "userSign" : inputF.text!, "birthDay" : birthDay])
            updateUserInfo(dic: dic)
        case .Birthday:
            dic = NSDictionary.init(dictionary: ["patientId" : patientId, "nickName" : nickName, "sex" : sex, "imgUrl" : imgUrl, "userSign" : userSign, "birthDay" : inputF.text!])
            updateUserInfo(dic: dic)
        default:
            HCPrint(message: "nothing")
        }
        
    }
    

    func updateUserInfo(dic : NSDictionary){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_updateUserInfo(dic: dic) { [weak self](success, message) in
            if success == true{
                HCShowInfo(info: "修改成功")
                UserManager.shareIntance.updateUserInfo(callback: { (success) in
                    if success == true {
                        let not = Notification.init(name: NSNotification.Name.init(UPDATE_USER_INFO), object: nil, userInfo: nil)
                        NotificationCenter.default.post(not)
                    }else{
                        HCShowError(info: "用户信息更新失败")
                    }
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                HCShowError(info: message)
            }
        }
    }
    
    func updateUserImg(patientId : NSInteger, nickName : String, sex : NSInteger, userSign : String, birthDay : String){
        
        SVProgressHUD.show()
        
        HttpRequestManager.shareIntance.HC_uploadSingleImg(img: selectedImg) { (success, str) in
            if success == true{
                HCShowInfo(info: "上传图片成功！")
                let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "nickName" : nickName, "sex" : sex, "imgUrl" : str, "userSign" : userSign, "birthDay" : birthDay])
                self.updateUserInfo(dic: dic)
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                HCShowError(info: str)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EditTextViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let l = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 40))
        l.text = sexArr[row]
        return l
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputF.text = sexArr[row]
    }
}

extension EditTextViewController {
    func takePhoto(){
        if checkCameraPermissions() {
            let photoVC = UIImagePickerController()
            photoVC.sourceType = UIImagePickerControllerSourceType.camera
            photoVC.delegate = self
            photoVC.allowsEditing = true
            photoVC.showsCameraControls = true
            UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
        }else{
            authorizationForCamera(confirmBlock: { [weak self]()in
                let photoVC = UIImagePickerController()
                photoVC.sourceType = UIImagePickerControllerSourceType.camera
                photoVC.delegate = self
                photoVC.allowsEditing = true
                photoVC.showsCameraControls = true
                UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
            })
            HCShowInfo(info: "请在手机设置-隐私-相机中开启权限")
        }
    }
    
    func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        systemPicVC.delegate = self
        systemPicVC.allowsEditing = true
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }
}

extension EditTextViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
//        UIImagePickerControllerOriginalImage   UIImagePickerControllerEditedImage
        let img = info["UIImagePickerControllerEditedImage"] as! UIImage
        selectedImg = img
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

