//
//  MessageTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var model : MessageDetailModel? {
        didSet{
            contentL.text = model?.content
            
            let num = model?.pushTime?.doubleValue
            let date = Date.init(timeIntervalSince1970: num! / 1000)
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let s = formatter.string(from: date)
            dateL.text = s
        }
    }
    
    lazy var contentL : UILabel = {
        let c = UILabel()
        c.font = UIFont.init(name: kReguleFont, size: 14)
        c.numberOfLines = 0
        return c
    }()
    
    lazy var dateL : UILabel = {
        let d = UILabel()
        d.font = UIFont.init(name: kReguleFont, size: 12)
        d.textColor = kLightTextColor
        return d
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(50)
            make.width.equalTo(SCREEN_WIDTH - 70)
        }
        
        let imgV = UIImageView()
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(contentL)
            make.top.equalTo(contentL.snp.bottom).offset(5)
            make.height.width.equalTo(15)
        }
        imgV.image = UIImage.init(named: "时间")
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        
        self.addSubview(dateL)
        dateL.snp.updateConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(10)
            make.centerY.equalTo(imgV)
            make.height.equalTo(15)
            make.width.equalTo(150)
            make.bottom.equalTo(self).offset(-20)
        }
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
