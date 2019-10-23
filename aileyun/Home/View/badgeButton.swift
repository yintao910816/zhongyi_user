//
//  badgeButton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/23.
//  Copyright © 2017年 huchuang. All rights reserved.
//
 
import UIKit

class badgeButton: UIButton {
    
    var number : NSInteger? {
        didSet{
            if let n = number{
                titelL.text = String.init(format: "%d", n)
                if n == 0{
                    titelL.isHidden = true
                }else{
                    titelL.isHidden = false
                }
            }
        }
    }

    let imgV = UIImageView()
    let titelL = UILabel()
    
    var isDown : Bool?{
        didSet{
            changeStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgV.image = UIImage.init(named: "信-黑")
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imgV)
        
        titelL.font = UIFont.init(name: kReguleFont, size: 12)
        titelL.textColor = UIColor.white
        titelL.textAlignment = NSTextAlignment.center
        titelL.backgroundColor = UIColor.red
        titelL.isHidden = true
        titelL.clipsToBounds = true
        self.addSubview(titelL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeStyle(){
        if isDown == true{
            imgV.image = UIImage.init(named: "信-黑")
        }else{
            imgV.image = UIImage.init(named: "消息")
        }
    }
    
    override func layoutSubviews() {
        let height = self.frame.size.height
        let width = self.frame.size.width
        
        imgV.frame = CGRect.init(x: 0, y: 0, width: width * 0.8, height: height)
        
        titelL.frame = CGRect.init(x: width * 0.6, y: height * 0.1, width: width * 0.5, height: width * 0.5)
        titelL.layer.cornerRadius = width * 0.25
    }

}
