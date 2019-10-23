//
//  selectView.swift
//  aileyun
//
//  Created by huchuang on 2017/6/20.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class selectView: UIView {
    
    lazy var guideBtn : titleImageButton = {
        let t = titleImageButton()
        t.titleL.text = "专家指导"
        t.contentL.text = "生育疑问快速响应"
        t.borderTitleL.text = "kind"

        t.textCol = kDefaultThemeColor
        t.imgV.image = UIImage.init(named: "指导")
        return t
    }()
    
    lazy var classroomBtn : titleImageButton = {
        let t = titleImageButton()
        t.titleL.text = "在线课堂"
        t.contentL.text = "让怀孕变得更简单"
        t.borderTitleL.text = "Easy"
        t.textCol = kDefaultBlueColor
        t.imgV.image = UIImage.init(named: "书籍")
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(guideBtn)
        
        self.addSubview(classroomBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        guideBtn.snp.updateConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH / 2)
            make.bottom.equalTo(self)
        }
        
        classroomBtn.snp.updateConstraints { (make) in
            make.top.equalTo(guideBtn)
            make.left.equalTo(guideBtn.snp.right)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
