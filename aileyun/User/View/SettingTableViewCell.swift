//
//  SettingTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    let titleL = UILabel()
    let RightImgV = UIImageView()
    let ImgV = UIImageView()
    let Img2V = UIImageView()
    
    
    var thirdArr : [String]? {
        didSet{
            if let thirdArr = thirdArr {
                if thirdArr.count > 0 {
                    if thirdArr[0] == "qq"{
                        ImgV.image = UIImage.init(named: "QQ02")
                    }else{
                        ImgV.image = UIImage.init(named: "微信02")
                    }
                    
                    if thirdArr.count == 2 {
                        if thirdArr[1] == "qq"{
                            Img2V.image = UIImage.init(named: "QQ02")
                        }else{
                            Img2V.image = UIImage.init(named: "微信02")
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.height.equalTo(self)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        titleL.textColor = kTextColor
        
        self.addSubview(RightImgV)
        RightImgV.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.height.equalTo(self)
            make.width.equalTo(20)
        }
        RightImgV.contentMode = .right
        RightImgV.image = UIImage.init(named: "箭头")
        
        self.addSubview(ImgV)
        ImgV.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(25)
        }
        ImgV.contentMode = .scaleAspectFit
        
        self.addSubview(Img2V)
        Img2V.snp.updateConstraints { (make) in
            make.right.equalTo(ImgV.snp.left).offset(-20)
            make.centerY.equalTo(self)
            make.height.width.equalTo(25)
        }
        Img2V.contentMode = .scaleAspectFit
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
