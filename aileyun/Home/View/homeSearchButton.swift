//
//  homeSearchButton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/20.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class homeSearchButton: UIButton {

    let infoLabel = UILabel()
    let searchIV = UIImageView()
    
    var isDown : Bool? = false{
        didSet{
            if isDown != oldValue{
                changeStyle()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kSearchBtnColor
        self.layer.cornerRadius = 16
        
        searchIV.image = UIImage.init(named: "搜索")
        self.addSubview(searchIV)
        
        infoLabel.text = "大咖开讲，你关心的这里都有"
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.init(name: kReguleFont, size: 14)
        self.addSubview(infoLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeStyle(){
        if isDown == true{
            searchIV.image = UIImage.init(named: "搜索-黑")
            infoLabel.textColor = UIColor.black
            self.backgroundColor = kdivisionColor
        }else{
            searchIV.image = UIImage.init(named: "搜索")
            infoLabel.textColor = UIColor.white
            self.backgroundColor = kSearchBtnColor
        }
    }
    
    override func layoutSubviews() {
        
        searchIV.snp.updateConstraints({ (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(20)
        })
        searchIV.contentMode = UIViewContentMode.scaleAspectFit
        
        infoLabel.snp.updateConstraints { (make) in
            make.left.equalTo(searchIV.snp.right).offset(10)
            make.centerY.equalTo(self)
        }
    }


}
