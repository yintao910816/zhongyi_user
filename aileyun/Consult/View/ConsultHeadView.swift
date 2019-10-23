//
//  ConsultHeadView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultHeadView: UIView {
    
    let headImgV = UIImageView()
    let nameL = UILabel()
    let statusL = UILabel()
    let divisionV = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(headImgV)
        headImgV.image = UIImage.init(named: "咨询-问")
        headImgV.contentMode = UIViewContentMode.scaleAspectFit
        
        self.addSubview(nameL)
        nameL.font = UIFont.init(name: kReguleFont, size: 15)
        nameL.textColor = kTextColor
        
        self.addSubview(statusL)
        statusL.font = UIFont.init(name: kReguleFont, size: 15)
        statusL.textColor = kTextColor
        statusL.textAlignment = NSTextAlignment.right
        
        self.addSubview(divisionV)
        divisionV.backgroundColor = kdivisionColor
    }
    
    convenience init?(frame : CGRect, name : String?, status : NSInteger?){
        self.init(frame: frame)
        nameL.text = name
        if let status = status {
            switch status {
            case -1:
                statusL.text = "未支付"
            case 0:
                statusL.text = "待回复"
            case 1:
                statusL.text = "已回复"
            case 2:
                statusL.text = "已回复"
            case 3:
                statusL.text = "超时退回"
            case 4:
                statusL.text = "系统退回"
            default:
                statusL.text = ""
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        headImgV.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(20)
            make.height.width.equalTo(40)
        }
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(headImgV)
            make.left.equalTo(headImgV.snp.right).offset(8)
            make.height.equalTo(20)
        }
        statusL.frame = CGRect.init(x: SCREEN_WIDTH - 80, y: 0, width: 60, height: 50)
        
        divisionV.frame = CGRect.init(x: 0, y: 49, width: SCREEN_WIDTH, height: 1)
    }

}
