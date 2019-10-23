//
//  CommetStarView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/20.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class CommentStarView: UIView {
    
    var clickBlock : ((NSInteger)->())?
    
    var numForStar = 5 {
        didSet{
            for j in imgVArr{
                j.isSelected = true
            }
            for i in 0..<numForStar{
                imgVArr[i].isSelected = false
            }
            
            if let clickBlock = clickBlock{
                clickBlock(numForStar)
            }
        }
    }
    
    var allowClick = false
    
    var imgVArr = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.size.width / 5
        let height = frame.size.height
        
        for i in 0..<5 {
            let starBtn = UIButton.init(frame: CGRect.init(x: width * CGFloat(i), y: 0, width: width, height: height))
            starBtn.tag = i + 1
            starBtn.setImage(UIImage.init(named: "评星2"), for: UIControlState.normal)
            starBtn.setImage(UIImage.init(named: "评星1"), for: UIControlState.selected)
            
            starBtn.addTarget(self, action: #selector(CommentStarView.chooseAction), for: UIControlEvents.touchUpInside)
            
            imgVArr.append(starBtn)
            
            self.addSubview(starBtn)
        }
        
    }
    
    func chooseAction(btn : UIButton){
        if allowClick == true {
            numForStar = btn.tag
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
