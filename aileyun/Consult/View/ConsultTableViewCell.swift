//
//  ConsultTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/13.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultTableViewCell: UITableViewCell {
    
    var model : ConsultDoctorModel?{
        didSet{
            if model?.picture != nil{
                imgV.HC_setImageFromURL(urlS: (model?.picture)!, placeHolder: "上传图片")
            }
            nameL.text = model?.doctorName
            jobL.text = model?.position
            priceL.text = model?.price
            hospitalL.text = model?.hospitalName
            replyL.text = String.init(format: "回复：%d", (model?.judgeCount)!)
            specialityL.text = model?.goodSkill
            
            commentV.numForStar = (model?.judgeStarCount?.intValue)!
        }
    }
    
    let imgV = UIImageView()
    let nameL = UILabel()
    let jobL = UILabel()
    let priceL = UILabel()
    
    let hospitalL = UILabel()
    let replyL = UILabel()
    
    let division1 = UIView()
    
    let titleL = UILabel()
    let specialityL = UILabel()
    
    let division2 = UIView()
    
    let commentL = UILabel()
    let commentV = starView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20))
    
    
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
            make.top.equalTo(imgV)
            make.left.equalTo(imgV.snp.right).offset(10)
            make.height.equalTo(15)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 14)
        nameL.textColor = kTextColor
        
        self.addSubview(jobL)
        jobL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL.snp.right).offset(5)
            make.centerY.equalTo(nameL)
            make.height.equalTo(10)
            make.width.equalTo(80)
        }
        jobL.font = UIFont.init(name: kReguleFont, size: 10)
        jobL.textColor = kLightTextColor
        
        self.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.top.equalTo(nameL)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        priceL.font = UIFont.init(name: kBoldFont, size: 13)
        priceL.textColor = kDefaultThemeColor
        priceL.textAlignment = NSTextAlignment.right
        
        self.addSubview(hospitalL)
        hospitalL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.bottom.equalTo(imgV.snp.bottom)
            make.height.equalTo(15)
        }
        hospitalL.font = UIFont.init(name: kReguleFont, size: 13)
        hospitalL.textColor = kTextColor
        
        self.addSubview(replyL)
        replyL.snp.updateConstraints { (make) in
            make.bottom.equalTo(imgV)
            make.right.equalTo(priceL)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        replyL.font = UIFont.init(name: kReguleFont, size: 10)
        replyL.textColor = kLightTextColor
        replyL.textAlignment = NSTextAlignment.right
        
        self.addSubview(division1)
        division1.snp.updateConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        division1.backgroundColor = kdivisionColor
        
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(imgV)
            make.top.equalTo(division1.snp.bottom).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(40)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: 12)
        titleL.textColor = kLightTextColor
        titleL.text = "专长："
        
        self.addSubview(specialityL)
        specialityL.snp.updateConstraints { (make) in
            make.left.equalTo(titleL.snp.right).offset(10)
            make.centerY.equalTo(titleL)
            make.width.equalTo(250)
        }
        specialityL.font = UIFont.init(name: kReguleFont, size: 12)
        specialityL.textColor = kLightTextColor
        
        
        self.addSubview(division2)
        division2.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        division2.backgroundColor = kdivisionColor
        
        self.addSubview(commentL)
        commentL.snp.updateConstraints { (make) in
            make.left.equalTo(imgV)
            make.top.equalTo(division2.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(65)
        }
        commentL.font = UIFont.init(name: kReguleFont, size: 13)
        commentL.textColor = kTextColor
        commentL.text = "用户评论："
        
        let containerV = UIView()
        self.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.left.equalTo(commentL.snp.right).offset(10)
            make.centerY.equalTo(commentL)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        containerV.addSubview(commentV)
        commentV.leftAligment = true
        
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
