//
//  ChatTextTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ChatTextTableViewCell: BaseChatTableViewCell {
    
    lazy var textL : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.init(name: kReguleFont, size: 14)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(textL)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var viewModel: HC_consultViewmodel? {
        didSet{
            textL.frame = viewModel?.wordsF ?? CGRect.zero
            textL.text = viewModel?.model?.content
            
            if viewModel?.model?.isDoctor == "0"{
                textL.textColor = kTextColor
            }else{
                textL.textColor = UIColor.white
            }
        }
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
