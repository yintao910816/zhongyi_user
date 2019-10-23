//
//  ConsultViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultViewCell: UITableViewCell {

    var model : DoctorModel?{
        didSet{
            if model?.imgUrl != nil{
                imgV.HC_setImageFromURL(urlS: (model?.imgUrl)!, placeHolder: "默认头像")
            }
            nameL.text = model?.realName
            jobL.text = model?.doctorRole
            
            if model?.consultation?.intValue == 1 {
                isConsultedL.isHidden = false
            }else{
                isConsultedL.isHidden = true
            }
            
            priceL.text = model?.docPrice
            hospitalL.text = model?.hospitalName
            replyL.text = String.init(format: "%d 条", (model?.consultCount?.intValue)!)
            specialityL.text = model?.goodProject
            
            commentV.numForStar = (model?.reviewStar?.intValue)!
        }
    }

    
    let imgV = UIImageView()
    let nameL = UILabel()
    let jobL = UILabel()
    
    let isConsultedL = UILabel()
    
    let priceL = UILabel()
    
    let hospitalL = UILabel()
    let replyL = UILabel()
    
    let titleL = UILabel()
    let specialityL = UILabel()
    
    let commentL = UILabel()
    let commentV = starView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20))
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.width.height.equalTo(50)
        }
        imgV.layer.cornerRadius = 25
        imgV.clipsToBounds = true
        imgV.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV).offset(-10)
            make.left.equalTo(imgV.snp.right).offset(10)
            make.height.equalTo(15)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 16)
        nameL.textColor = kTextColor
        
        self.addSubview(jobL)
        jobL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL.snp.right).offset(5)
            make.centerY.equalTo(nameL)
            make.height.equalTo(10)
        }
        jobL.font = UIFont.init(name: kReguleFont, size: 12)
        jobL.textColor = kLightTextColor
        
        
        self.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.top.equalTo(nameL)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        priceL.font = UIFont.init(name: kReguleFont, size: 14)
        priceL.textColor = kDefaultThemeColor
        priceL.textAlignment = NSTextAlignment.right
        
        self.addSubview(hospitalL)
        hospitalL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.centerY.equalTo(imgV).offset(15)
            make.height.equalTo(15)
        }
        hospitalL.font = UIFont.init(name: kReguleFont, size: 14)
        hospitalL.textColor = kTextColor
        
        
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(hospitalL)
            make.top.equalTo(hospitalL.snp.bottom).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(40)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: 12)
        titleL.textColor = kLightTextColor
        titleL.text = "专长："
        
        self.addSubview(specialityL)
        specialityL.snp.updateConstraints { (make) in
            make.left.equalTo(titleL.snp.right)
            make.centerY.equalTo(titleL)
            make.right.equalTo(priceL)
        }
        specialityL.font = UIFont.init(name: kReguleFont, size: 12)
        specialityL.textColor = kLightTextColor
        
        
        let containerV = UIView()
        self.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.left.equalTo(titleL)
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        containerV.addSubview(commentV)
        commentV.leftAligment = true
        
        self.addSubview(replyL)
        replyL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV.snp.right)
            make.centerY.equalTo(containerV)
            make.height.equalTo(15)
        }
        replyL.font = UIFont.init(name: kReguleFont, size: 10)
        replyL.textColor = kLightTextColor
        replyL.textAlignment = NSTextAlignment.right
        
        self.addSubview(isConsultedL)
        isConsultedL.snp.updateConstraints {(make) in
            make.centerX.equalTo(imgV)
            make.top.equalTo(imgV.snp.bottom).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(14)
        }
        isConsultedL.text = "咨询过"
        isConsultedL.textAlignment = NSTextAlignment.center
        isConsultedL.clipsToBounds = true
        isConsultedL.font = UIFont.init(name: kReguleFont, size: 10)
        isConsultedL.backgroundColor = kDefaultThemeColor
        isConsultedL.layer.cornerRadius = 7
        isConsultedL.textColor = UIColor.white
        isConsultedL.isHidden = true

        
        
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
