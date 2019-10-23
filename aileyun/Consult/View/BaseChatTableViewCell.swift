//
//  BaseChatTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BaseChatTableViewCell: UITableViewCell {
    var showPhotoBlock : (([String])->())?
    var convertBlock : ((_ p : CGPoint)->CGPoint)?
    
    let headImgV = UIImageView()
    
    lazy var bubbleV : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    let timeL = UILabel()
    
    var viewModel : HC_consultViewmodel?{
        didSet{
            headImgV.frame = viewModel?.headIVF ?? CGRect.zero
            bubbleV.frame = viewModel?.bubbleF ?? CGRect.zero
            timeL.frame = viewModel?.timeF ?? CGRect.zero
            
            if let imgS = viewModel?.model?.headImg{
                headImgV.HC_setImageFromURL(urlS: imgS, placeHolder: "默认头像")
            }else{
                headImgV.image = UIImage.init(named: "默认头像")
            }
            
            timeL.text = viewModel?.model?.createT
            
            if viewModel?.model?.isDoctor == "0"{
                bubbleV.backgroundColor = klightGrayColor
                timeL.textColor = kTextColor
            }else{
                bubbleV.backgroundColor = kDefaultThemeColor
                timeL.textColor = UIColor.white
            }
            
        }
    }

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.addSubview(headImgV)
        headImgV.layer.cornerRadius = 20
        headImgV.clipsToBounds = true
        headImgV.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(bubbleV)
        
        self.addSubview(timeL)
        timeL.font = UIFont.init(name: kReguleFont, size: 14)
        timeL.textAlignment = NSTextAlignment.right
        
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

extension BaseChatTableViewCell : GetPhotoCenterDelegate {
    func getPhotoCenter()->CGPoint{
        HCPrint(message: "base ***** ******")
        return CGPoint.zero
    }
    
    func getImage()->UIImage{
        HCPrint(message: "base ***** ******")
        return UIImage.init()
    }
}
