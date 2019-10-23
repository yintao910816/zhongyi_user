//
//  UserTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    let titleL = UILabel()
    let imgV = UIImageView()
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
