//
//  ConsultedTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/13.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultedTableViewCell: UITableViewCell {
    
    var model : ConsultedModel?{
        didSet{
            imgV.HC_setImageFromURL(urlS: (model?.doctorImg)!, placeHolder: "上传图片")
            nameL.text = model?.doctorName
            jobL.text = model?.doctorRole
        }
    }
    
    let imgV = UIImageView()
    let nameL = UILabel()
    let jobL = UILabel()
    
    let consultBtn = UIButton()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.left.equalTo(imgV.snp.right).offset(10)
            make.height.equalTo(15)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 14)
        nameL.textColor = kTextColor
        
        self.addSubview(jobL)
        jobL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL.snp.right).offset(5)
            make.centerY.equalTo(nameL)
        }
        jobL.font = UIFont.init(name: kReguleFont, size: 12)
        jobL.textColor = kLightTextColor
        
        self.addSubview(consultBtn)
        consultBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(imgV)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        consultBtn.setTitle("再次咨询", for: UIControlState.normal)
        consultBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        consultBtn.setTitleColor(kDefaultThemeColor, for: UIControlState.normal)
        consultBtn.layer.cornerRadius = 5
        consultBtn.layer.borderWidth = 0.5
        consultBtn.layer.borderColor = kDefaultThemeColor.cgColor
        
        consultBtn.isUserInteractionEnabled = false
        
        let division = UIView()
        self.addSubview(division)
        division.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(2)
        }
        division.backgroundColor = klightGrayColor
        
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
