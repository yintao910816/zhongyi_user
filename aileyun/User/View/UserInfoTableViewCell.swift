//
//  UserInfoTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    let titleL = UILabel()
    let contentL = UILabel()
    let imgV = UIImageView()
    let headImgV = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.height.equalTo(self)
            make.width.equalTo(100)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        titleL.textColor = kTextColor
        
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.height.equalTo(self)
            make.width.equalTo(20)
        }
        imgV.contentMode = UIViewContentMode.right
        imgV.image = UIImage.init(named: "箭头")
        
        self.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.right.equalTo(imgV.snp.left)
            make.centerY.height.equalTo(self)
            make.left.equalTo(titleL.snp.right).offset(10)
        }
        contentL.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        contentL.textColor = kLightTextColor
        contentL.textAlignment = NSTextAlignment.right
        
        self.addSubview(headImgV)
        headImgV.snp.updateConstraints { (make) in
            make.right.equalTo(imgV.snp.left)
            make.centerY.equalTo(self)
            make.height.width.equalTo(40)
        }
        headImgV.layer.cornerRadius = 20
        headImgV.clipsToBounds = true
        headImgV.contentMode = UIViewContentMode.scaleAspectFill
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
