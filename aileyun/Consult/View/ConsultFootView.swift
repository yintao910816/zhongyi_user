//
//  ConsultFootView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultFootView: UIView {
    
    var btnBlock : ((NSInteger)->())?
    
    let priceL = UILabel()
    
    let payBtn = UIButton()
    let modifyBtn = UIButton()
    
    let deleteBtn = UIButton()
    
    let reConsultBtn = UIButton()
    let commmentBtn = UIButton()
    let checkCommentBtn = UIButton()
    
    let topDivisionV = UIView()
    
    let divisionV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(topDivisionV)
        topDivisionV.backgroundColor = kdivisionColor
        
        self.addSubview(priceL)
        priceL.font = UIFont.init(name: kReguleFont, size: 13)
        priceL.textColor = kTextColor
        priceL.textAlignment = NSTextAlignment.right
        
        self.addSubview(payBtn)
        payBtn.setTitle("马上支付", for: UIControlState.normal)
        payBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        payBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        payBtn.layer.cornerRadius = 15
        payBtn.layer.borderWidth = 1
        payBtn.layer.borderColor = kDefaultThemeColor.cgColor
        payBtn.tag = 101
        payBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)
        
        self.addSubview(modifyBtn)
        modifyBtn.setTitle("修改咨询", for: UIControlState.normal)
        modifyBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        modifyBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        modifyBtn.layer.cornerRadius = 15
        modifyBtn.layer.borderWidth = 1
        modifyBtn.layer.borderColor = kDefaultThemeColor.cgColor
        modifyBtn.tag = 102
        modifyBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)
        
        self.addSubview(deleteBtn)
        deleteBtn.setTitle("删除咨询", for: UIControlState.normal)
        deleteBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        deleteBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = kDefaultThemeColor.cgColor
        deleteBtn.tag = 106
        deleteBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)


        self.addSubview(reConsultBtn)
        reConsultBtn.setTitle("再次咨询", for: UIControlState.normal)
        reConsultBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        reConsultBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        reConsultBtn.layer.cornerRadius = 15
        reConsultBtn.layer.borderWidth = 1
        reConsultBtn.layer.borderColor = kDefaultThemeColor.cgColor
        reConsultBtn.tag = 103
        reConsultBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)

        self.addSubview(commmentBtn)
        commmentBtn.setTitle("马上评价", for: UIControlState.normal)
        commmentBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        commmentBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        commmentBtn.layer.cornerRadius = 15
        commmentBtn.layer.borderWidth = 1
        commmentBtn.layer.borderColor = kDefaultThemeColor.cgColor
        commmentBtn.tag = 104
        commmentBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)

        self.addSubview(checkCommentBtn)
        checkCommentBtn.setTitle("查看评价", for: UIControlState.normal)
        checkCommentBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        checkCommentBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 15)
        checkCommentBtn.layer.cornerRadius = 15
        checkCommentBtn.layer.borderWidth = 1
        checkCommentBtn.layer.borderColor = kDefaultThemeColor.cgColor
        checkCommentBtn.tag = 105
        checkCommentBtn.addTarget(self, action: #selector(ConsultFootView.btnClick), for: UIControlEvents.touchUpInside)
        
        self.addSubview(divisionV)
        divisionV.backgroundColor = kdivisionColor

    }
    
    convenience init?(_ frame : CGRect, type : String, isEvaluation : NSInteger, price : String, callback : @escaping (NSInteger)->()){
        self.init(frame: frame)
        
        priceL.text = "咨询费用：￥" + price
        btnBlock = callback
        if type == "未支付"{
            payBtn.isHidden = false
            modifyBtn.isHidden = false
            deleteBtn.isHidden = false
            reConsultBtn.isHidden = true
            commmentBtn.isHidden = true
            checkCommentBtn.isHidden = true
        }else if type == "已回复"{
            payBtn.isHidden = true
            modifyBtn.isHidden = true
            deleteBtn.isHidden = true
            reConsultBtn.isHidden = false
            if isEvaluation == 1 {
                commmentBtn.isHidden = true
                checkCommentBtn.isHidden = false
            }else{
                commmentBtn.isHidden = false
                checkCommentBtn.isHidden = true
            }
        }else if type == "已退回"{
            payBtn.isHidden = true
            modifyBtn.isHidden = true
            deleteBtn.isHidden = true
            reConsultBtn.isHidden = false
            commmentBtn.isHidden = true
            checkCommentBtn.isHidden = true
        }
    }
    
    func btnClick(btn : UIButton){
        btnBlock!(btn.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        topDivisionV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 1)
        
        priceL.frame = CGRect.init(x: SCREEN_WIDTH - 220, y: 5, width: 200, height: 30)
        
        payBtn.frame = CGRect.init(x: SCREEN_WIDTH - 105, y: 40, width: 85, height: 30)
        
        modifyBtn.snp.updateConstraints { (make) in
            make.right.equalTo(payBtn.snp.left).offset(-10)
            make.centerY.equalTo(payBtn)
            make.width.height.equalTo(payBtn)
        }
        
        deleteBtn.snp.updateConstraints { (make) in
            make.right.equalTo(modifyBtn.snp.left).offset(-10)
            make.centerY.equalTo(payBtn)
            make.width.height.equalTo(payBtn)
        }
        
        reConsultBtn.frame = CGRect.init(x: SCREEN_WIDTH - 105, y: 40, width: 85, height: 30)
        
        commmentBtn.snp.updateConstraints { (make) in
            make.right.equalTo(payBtn.snp.left).offset(-10)
            make.centerY.equalTo(payBtn)
            make.width.height.equalTo(payBtn)
        }
        
        checkCommentBtn.snp.updateConstraints { (make) in
            make.right.equalTo(payBtn.snp.left).offset(-10)
            make.centerY.equalTo(payBtn)
            make.width.height.equalTo(payBtn)
        }
        
        divisionV.frame = CGRect.init(x: 0, y: 75, width: SCREEN_WIDTH, height: 5)
    }

}
