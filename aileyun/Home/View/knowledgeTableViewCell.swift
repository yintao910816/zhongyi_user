//
//  knowledgeTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/6/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class knowledgeTableViewCell: UITableViewCell {
    
    var model : KnowledgeModel? {
        didSet{
            if model?.COVER_PIC != nil{
                imgV.HC_setImageFromURL(urlS: (model?.COVER_PIC)!, placeHolder: "上传图片")
            }
            titleL.text = model?.TITLE
            
            contentL.text = model?.DIGEST
        }
    }
    
    let imgV = UIImageView()
    let titleL = UILabel()
    let contentL = UILabel()
    
    let readL = UILabel()
    let commentL = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    
        self.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.width.height.equalTo(80)
        }
        
        titleL.font = UIFont.init(name: kReguleFont, size: 16)
        titleL.textColor = kTextColor
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(imgV.snp.right).offset(15)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(27)
        }
        
        contentL.font = UIFont.init(name: kReguleFont, size: 14)
        contentL.textColor = kLightTextColor
        self.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom)
            make.left.right.equalTo(titleL)
            make.height.equalTo(26)
        }
        
        let i = 100 + arc4random_uniform(200)
        commentL.text = String.init(format: "%d", i)
        commentL.textColor = kNumberColor
        commentL.textAlignment = NSTextAlignment.center
        commentL.font = UIFont.init(name: kReguleFont, size: 12)
        self.addSubview(commentL)
        commentL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(contentL.snp.bottom)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(30)
        }
        
        let commentIV = UIImageView()
        commentIV.image = UIImage.init(named: "评论量")
        commentIV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(commentIV)
        commentIV.snp.updateConstraints { (make) in
            make.right.equalTo(commentL.snp.left)
            make.centerY.equalTo(commentL)
            make.width.height.equalTo(14)
        }
        
        let j = 300 + arc4random_uniform(200)
        readL.text = String.init(format: "%d", j)
        readL.textColor = kNumberColor
        readL.textAlignment = NSTextAlignment.center
        readL.font = UIFont.init(name: kReguleFont, size: 12)
        self.addSubview(readL)
        readL.snp.updateConstraints { (make) in
            make.right.equalTo(commentIV.snp.left)
            make.centerY.equalTo(commentL)
            make.width.equalTo(30)
        }
        
        let readIV = UIImageView()
        readIV.image = UIImage.init(named: "浏览量")
        readIV.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(readIV)
        readIV.snp.updateConstraints { (make) in
            make.right.equalTo(readL.snp.left)
            make.centerY.equalTo(commentL)
            make.width.height.equalTo(14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
