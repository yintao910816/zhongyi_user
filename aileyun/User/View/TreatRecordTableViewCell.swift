//
//  TreatRecordTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class TreatRecordTableViewCell: UITableViewCell {
    
    lazy var hospitalL : UILabel = {
        let h = UILabel()
        h.font = UIFont.init(name: kBoldFont, size: 10)
        return h
    }()
    
    lazy var stageL : UILabel = {
        let s = UILabel()
        s.font = UIFont.init(name: kReguleFont, size: 12)
        s.textColor = kDefaultThemeColor
        return s
    }()
    
    lazy var dateL : UILabel = {
        let d = UILabel()
        d.font = UIFont.init(name: kReguleFont, size: 12)
        d.textColor = kLightTextColor
        return d
    }()
    
    lazy var contentL : UILabel = {
        let c = UILabel()
        c.font = UIFont.init(name: kReguleFont, size: 13)
        c.textColor = kTextColor
        c.numberOfLines = 0
        return c
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = klightGrayColor
        
        let containerV = UIView()
        containerV.layer.cornerRadius = 5
        containerV.layer.shadowColor = kdivisionColor.cgColor
        containerV.layer.shadowRadius = 5
        containerV.layer.shadowOpacity = 1
        containerV.backgroundColor = UIColor.white
        self.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.left.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-5)
        }
        
        
        containerV.addSubview(hospitalL)
        hospitalL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(15)
            make.top.equalTo(containerV).offset(10)
            make.height.equalTo(20)
        }
        
        let redV = UIView()
        redV.backgroundColor = kDefaultThemeColor
        containerV.addSubview(redV)
        redV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV)
            make.centerY.equalTo(hospitalL)
            make.width.equalTo(5)
            make.height.equalTo(20)
        }
        
        containerV.addSubview(stageL)
        stageL.snp.updateConstraints { (make) in
            make.centerY.equalTo(hospitalL)
            make.right.equalTo(containerV).offset(-15)
            make.height.equalTo(20)
        }
        
        containerV.addSubview(dateL)
        dateL.snp.updateConstraints { (make) in
            make.right.equalTo(stageL.snp.left).offset(-10)
            make.centerY.equalTo(hospitalL)
            make.height.equalTo(20)
        }
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.equalTo(containerV)
            make.top.equalTo(hospitalL.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        let titleL = UILabel()
        containerV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(divisionV.snp.bottom).offset(10)
            make.left.equalTo(hospitalL)
            make.height.equalTo(15)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: 13)
        titleL.textColor = kLightTextColor
        titleL.text = "就诊病历"
        
        containerV.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.left.equalTo(hospitalL)
            make.right.equalTo(stageL)
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.bottom.equalTo(containerV.snp.bottom).offset(-15)
        }
        
        debug()
    }
    
    func debug(){
        hospitalL.text = "湖北省妇幼保健院"
        stageL.text = "[初诊]"
        dateL.text = "2017-8-5 10:30:18"
        
        contentL.text = "测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容，测试内容"
    }
        

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
