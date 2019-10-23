//
//  CommentDocViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentDocViewController: BaseViewController {
    
    var consultId : NSNumber?
    var doctorId : NSNumber?
    
    var doctorName : String?{
        didSet{
            titleL.text = "整体评价：" + doctorName!
        }
    }
    
    var isCheck : Bool?{
        didSet{
            if isCheck == true {
                starV.allowClick = false
                textV.isEditable = false
                commitCommentBtn.isHidden = true
                
                requestComment()
            }
        }
    }
    
    var commentModel : DoctorCommentModel?{
        didSet{
            starV.numForStar = Int((commentModel?.other)!)!
            textV.text = commentModel?.discribe
            textV.placeholdL.isHidden = true
        }
    }
    
    lazy var titleL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 16)
        l.textColor = kTextColor
        return l
    }()
    
    lazy var starV : CommentStarView = {
        let s = CommentStarView.init(frame: CGRect.init(x: (SCREEN_WIDTH - 200) * 0.5, y: 100, width: 200, height: 30))
        s.allowClick = true
        return s
    }()
    
    lazy var starL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 15)
        l.textColor = kDefaultThemeColor
        return l
    }()
    
    lazy var textV : PlaceHolderTextView = {
        let t = PlaceHolderTextView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 60, height: 100), textContainer: nil)
        t.placeholdS = "请在此写下您对医生的评价，愿意为您提供更好的服务"
        t.font = UIFont.init(name: kReguleFont, size: 14)
        t.textColor = kTextColor
        t.layer.borderWidth = 1
        t.layer.borderColor = kdivisionColor.cgColor
        t.layer.cornerRadius = 3
        return t
    }()
    
    lazy var commitCommentBtn : UIButton = {
        let b = UIButton()
        b.setTitle("提交评论", for: UIControlState.normal)
        b.backgroundColor = kDefaultThemeColor
        b.layer.cornerRadius = 5
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "匿名评价"

        initUI()
        
        starV.clickBlock = {[weak self](i)in
            if i == 1 {
                self?.starL.text = "很不满意"
            }else if i == 2 {
                self?.starL.text = "不满意"
            }else if i == 3 {
                self?.starL.text = "一般"
            }else if i == 4 {
                self?.starL.text = "满意"
            }else if i == 5 {
                self?.starL.text = "很满意"
            }
        }
    }
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        let containV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        containV.backgroundColor = UIColor.white
        self.view.addSubview(containV)
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(CommentDocViewController.editEnd))
        containV.addGestureRecognizer(tapG)
        
        containV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(containV).offset(40)
            make.centerX.equalTo(containV)
            make.height.equalTo(20)
        }
        
        containV.addSubview(starV)
        
        containV.addSubview(starL)
        starL.snp.updateConstraints { (make) in
            make.top.equalTo(starV.snp.bottom).offset(20)
            make.centerX.equalTo(containV)
            make.height.equalTo(20)
        }
        starL.text = "很满意"
        
        containV.addSubview(textV)
        textV.snp.updateConstraints { (make) in
            make.left.equalTo(containV).offset(30)
            make.right.equalTo(containV).offset(-30)
            make.top.equalTo(starL.snp.bottom).offset(40)
            make.height.equalTo(150)
        }
        
        containV.addSubview(commitCommentBtn)
        commitCommentBtn.snp.updateConstraints { (make) in
            make.top.equalTo(textV.snp.bottom).offset(30)
            make.centerX.equalTo(containV)
            make.width.equalTo(200)
            make.height.equalTo(35)
        }
        
        commitCommentBtn.addTarget(self, action: #selector(CommentDocViewController.commitComment), for: UIControlEvents.touchUpInside)
    }
    
    func editEnd(){
        self.view.endEditing(true)
    }
    
    func commitComment(){
        
        SVProgressHUD.show()
        
        HttpRequestManager.shareIntance.HC_reviewConsult(consultId: (consultId?.intValue)!, content: textV.text, doctorId: String.init(format: "%d", (doctorId?.intValue)!), count: starV.numForStar) {[weak self](success, msg) in
            if success == true{
                HCShowInfo(info: msg)
                self?.navigationController?.popToRootViewController(animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
    }
    
    func requestComment(){
        let s = String.init(format: "%d", (consultId?.intValue)!)
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.getCommentFor(consultId: s) { [weak self](success, model) in
            if success == true{
                SVProgressHUD.dismiss()
                self?.commentModel = model
            }else{
                HCShowError(info: "请求失败！")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
