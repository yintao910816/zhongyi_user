//
//  NotiveViewTVCell.swift
//  aileyun
//
//  Created by huchuang on 2017/12/28.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class NotiveViewTVCell: UITableViewCell {

    var model : NoticeHomeVModel?{
        didSet{
            if let model = model{
                titleL.text = model.content
            }
        }
    }
    
    lazy var titleL : UILabel = {
        let t = UILabel.init(frame: CGRect.init(x: 15, y: 5, width: SCREEN_WIDTH - 55, height: 40))
        t.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        t.numberOfLines = 2
        t.lineBreakMode = .byCharWrapping
        t.textColor = kTextColor
        return t
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    func initUI(){
        let redV = UIView.init(frame: CGRect.init(x: 0, y: 12, width: 6, height: 6))
        redV.layer.cornerRadius = 3
        redV.clipsToBounds = true
        redV.backgroundColor = kDefaultThemeColor
        self.addSubview(redV)
        
        self.addSubview(titleL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

