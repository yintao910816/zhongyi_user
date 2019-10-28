//
//  starView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/7.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class starView: UIView {
    var leftAligment : Bool = false
    
    let padding : CGFloat = 2
    
    var numForStar = 5 {
        didSet{
            if leftAligment == false{
                for i in imgVArr {
                    if i.tag > numForStar{
                        i.isHidden = true
                    }else{
                        i.isHidden = false
                    }
                }
            }else{
                for j in imgVArr{
                    j.isHidden = true
                }
                for i in 0..<numForStar{
                    imgVArr[i].isHidden = false
                }
            }
        }
    }
    
    var imgVArr = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.size.width / 5
        let w = width - padding * 2
        let height = frame.size.height - padding * 2
        
        for i in 0..<5 {
            let x = padding + width * CGFloat(i)
            
            let starV = UIImageView.init(frame: CGRect.init(x: x, y: padding, width: w, height: height))
            starV.tag = 5 - i
            starV.image = UIImage.init(named: "星级")
            starV.contentMode = .scaleAspectFit
            
            imgVArr.append(starV)
            
            self.addSubview(starV)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
