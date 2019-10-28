//
//  groupCollectionViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/6/23.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class groupCollectionViewCell: UICollectionViewCell {
    var urlStr : String?{
        didSet{
            imgV.HC_setImageFromURL(urlS: urlStr!, placeHolder: "placehold")
        }
    }
    
    let imgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgV.contentMode = .scaleToFill
        self.addSubview(imgV)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imgV.frame = bounds
    }

}
