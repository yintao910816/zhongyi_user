//
//  MessageGroupViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class MessageGroupViewCell: UITableViewCell {

    var model : messageGroupModel? {
        didSet{
            if let n = model?.type{
                let number = n.intValue
                switch number{
                case 0:
                    imgV.image = UIImage.init(named: "系")
                    indicateL.text = "查看详情"
                case 21:
                    imgV.image = UIImage.init(named: "论")
                    indicateL.text = "去看看"
                case 22:
                    imgV.image = UIImage.init(named: "咨")
                    indicateL.text = "查看详情"
                default:
                    imgV.image = UIImage.init(named: "诊")
                    indicateL.text = "去看看"
                }
            }else{
                imgV.image = UIImage.init(named: "诊")
                indicateL.text = "去看看"
            }
            
            titleL.text = model?.title
            contentL.text = model?.content
            
            let num = model?.pushTime?.doubleValue
            if num != nil{
                let date = Date.init(timeIntervalSince1970: num! / 1000)
                let formatter = DateFormatter.init()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let s = formatter.string(from: date)
                dateL.text = s
            }
            
            if let u = model?.notifyGroupCount{
                if u == NSNumber.init(value: 0){
                    unreadL.isHidden = true
                    unreadL.text = ""
                }else{
                    unreadL.text = String.init(format: "未读消息（%d）", u.intValue)
                    unreadL.isHidden = false
                }
            }else{
                unreadL.isHidden = true
            }
        }
    }
    
    let contV = UIView.init()
    
    lazy var imgV : UIImageView = {
        let i = UIImageView.init(frame: CGRect.init(x: 5, y: 5, width: 25, height:25))
        return i
    }()
    
    lazy var titleL : UILabel = {
        let t = UILabel.init()
        t.font = UIFont.init(name: kReguleFont, size: 14)
        t.textColor = kTextColor
        return t
    }()
    
    lazy var dateL : UILabel = {
        let d = UILabel()
        d.font = UIFont.init(name: kReguleFont, size: 10)
        d.textColor = kLightTextColor
        return d
    }()
    
    lazy var unreadL : UILabel = {
        let u = UILabel.init()
        u.font = UIFont.init(name: kReguleFont, size: 14)
        u.textColor = kDefaultThemeColor
        return u
    }()
    
    lazy var contentL : UILabel = {
        let c = UILabel()
        c.font = UIFont.init(name: kReguleFont, size: 14)
        c.textColor = kTextColor
        c.numberOfLines = 0
        return c
    }()
    
    lazy var indicateL : UILabel = {
        let i = UILabel.init()
        i.font = UIFont.init(name: kReguleFont, size: 14)
        i.textAlignment = .center
        i.textColor = kTextColor
        return i
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = klightGrayColor
        
        contV.backgroundColor = UIColor.white
        self.addSubview(contV)
        contV.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(5)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalTo(self).offset(-5)
        }
        
        contV.addSubview(imgV)
        
        contV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.height.equalTo(20)
            make.left.equalTo(imgV.snp.right).offset(5)
        }
        
        contV.addSubview(dateL)
        dateL.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(3)
            make.height.equalTo(15)
            make.left.equalTo(titleL)
        }
        
        contV.addSubview(unreadL)
        unreadL.snp.updateConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.right.equalTo(contV).offset(-5)
        }
        
        contV.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.top.equalTo(dateL.snp.bottom).offset(5)
            make.left.equalTo(dateL)
            make.width.equalTo(SCREEN_WIDTH - 70)
        }
        
        let divisionV = UIView()
        divisionV.backgroundColor = kdivisionColor
        contV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(contentL.snp.bottom).offset(5)
            make.left.equalTo(contV)
            make.height.equalTo(1)
            make.width.equalTo(contV)
        }
        
        contV.addSubview(indicateL)
        indicateL.snp.updateConstraints { (make) in
            make.top.equalTo(divisionV.snp.bottom).offset(5)
            make.left.equalTo(contV)
            make.width.equalTo(contV)
            make.height.equalTo(20)
            make.bottom.equalTo(contV).offset(-5)
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
