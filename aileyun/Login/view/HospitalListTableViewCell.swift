//
//  HospitalListTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/3.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HospitalListTableViewCell: UITableViewCell {
    
    let img = UIImageView()
    
    let nameL = UILabel()
    
    let distanceL = UILabel()
    
    let addressL = UILabel()
    
    var model : HospitalListModel? {
        didSet{
            img.HC_setImageFromURL(urlS: (model?.other)!, placeHolder: "上传图片")
            nameL.text = model?.name
            if let d = model?.discribe{
                distanceL.text = d + "km"
            }
            if let s = model?.address{
                addressL.text = s
            }else{
                addressL.text = model?.name
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.addSubview(img)
        img.snp.updateConstraints { (make) in
            make.left.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(80)
        }
        
        self.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.bottom.equalTo(img.snp.centerY).offset(-5)
            make.left.equalTo(img.snp.right).offset(10)
            make.height.equalTo(20)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 15)
        nameL.textColor = kTextColor
        
        self.addSubview(distanceL)
        distanceL.snp.updateConstraints { (make) in
            make.centerY.equalTo(nameL)
            make.left.equalTo(nameL.snp.right).offset(10)
            make.height.equalTo(20)
            make.right.equalTo(self).offset(-20)
        }
        distanceL.font = UIFont.init(name: kReguleFont, size: 14)
        distanceL.textColor = kLightTextColor
        
        let imgV = UIImageView.init(image: UIImage.init(named: "地址"))
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.top.equalTo(img.snp.centerY).offset(5)
            make.left.equalTo(nameL)
            make.width.equalTo(10)
            make.height.equalTo(15)
        }
        
        self.addSubview(addressL)
        addressL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.left.equalTo(imgV.snp.right).offset(5)
            make.height.equalTo(20)
            make.right.equalTo(self).offset(-20)
        }
        addressL.font = UIFont.init(name: kReguleFont, size: 14)
        addressL.textColor = kLightTextColor
        
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
