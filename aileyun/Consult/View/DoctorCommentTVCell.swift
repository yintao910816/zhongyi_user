//
//  DoctorCommentTVCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorCommentTVCell: UITableViewCell {
    
    var model : CommentDocModel? {
        didSet{
            nameL.text = model?.patientAccount
            contentL.text = model?.reviewContent
            starV.numForStar = (model?.reviewCount?.intValue)!
        }
    }
    
    lazy var nameL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 13)
        l.textColor = kLightTextColor
        return l
    }()
    
    lazy var contentL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 11)
        l.textColor = kTextColor
        l.numberOfLines = 0
        return l
    }()
    
    lazy var starV : starView = {
        let s = starView.init(frame: CGRect.init(x: SCREEN_WIDTH - 120, y: 10, width: 100, height: 20))
        s.leftAligment = false
        s.numForStar = 3
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameL)
        self.addSubview(contentL)
        self.addSubview(starV)
        
        nameL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(15)
        }
        
        contentL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(nameL.snp.bottom).offset(10)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-10)
        }
        
//        debug()
    }
    
    func debug(){
        nameL.text = "188****5748"
        contentL.text = "好评，好大夫，厉害，牛"
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
