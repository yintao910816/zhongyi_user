//
//  DoctorAttentionTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorAttentionTableViewCell: UITableViewCell {
    
    var model : DoctorAttentionModel?{
        didSet{
            if model?.imgUrl != nil{
                imgV.HC_setImageFromURL(urlS: (model?.imgUrl)!, placeHolder: "上传图片")
            }
            
            nameL.text = model?.doctorName
            jobL.text = model?.doctorRoleName
            
        }
    }
    
    
    let imgV = UIImageView()
    let nameL = UILabel()
    let jobL = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.width.height.equalTo(40)
        }
        imgV.layer.cornerRadius = 20
        imgV.clipsToBounds = true
        
        self.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.left.equalTo(imgV.snp.right).offset(10)
            make.height.equalTo(20)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 16)
        nameL.textColor = kTextColor
        
        self.addSubview(jobL)
        jobL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL.snp.right).offset(10)
            make.centerY.equalTo(nameL)
            make.height.equalTo(20)
        }
        jobL.font = UIFont.init(name: kReguleFont, size: 12)
        jobL.textColor = kLightTextColor
        
        let division3 = UIView()
        self.addSubview(division3)
        division3.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(2)
        }
        division3.backgroundColor = klightGrayColor
        
        
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
