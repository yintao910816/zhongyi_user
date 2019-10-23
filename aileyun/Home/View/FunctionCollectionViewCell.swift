//
//  FunctionCollectionViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/8/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class FunctionCollectionViewCell: UICollectionViewCell {
    
    let imgV = UIImageView()
    let titleL = UILabel()
    
    
    var model : HomeFunctionModel?{
        didSet{
            if let p = model?.path{
//                HCFindImageTool.shareIntance.HC_setImage(key: (model?.code)!, url: (model?.path)!, imgV: imgV)
                imgV.HC_setImageFromURL(urlS: p, placeHolder: "上传图片")
            }else{
                imgV.image = UIImage.init(named: (model?.name)!)
            }
            titleL.text = model?.name
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ratio : CGFloat = 0.6
        
        imgV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imgV)
        imgV.frame = CGRect.init(x: 0, y: 10, width: frame.size.width, height: frame.size.height * ratio)
        
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        titleL.textColor = kTextColor
        titleL.textAlignment = NSTextAlignment.center
        self.addSubview(titleL)
        titleL.frame = CGRect.init(x: 0, y: frame.size.height * ratio + 10, width: frame.size.width, height: frame.size.height * (1 - ratio) - 10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
