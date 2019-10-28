//
//  ChatPicTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ChatPicTableViewCell: BaseChatTableViewCell {

    let imgV = UIImageView()
    
    var cellCenter = CGPoint.zero
    var cellImage = UIImage.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(imgV)
        imgV.layer.cornerRadius = 20
        imgV.clipsToBounds = true
        imgV.isUserInteractionEnabled = true
        imgV.contentMode = .scaleToFill
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapPic))
        imgV.addGestureRecognizer(tapG)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var viewModel: HC_consultViewmodel? {
        didSet{
            imgV.frame = viewModel?.picF ?? CGRect.zero
            
            imgV.HC_setImageFromURL(urlS: (viewModel?.model?.imageList)!, placeHolder: "上传图片")
        }
    }
    
    func getPhotoCenter()->CGPoint{
        HCPrint(message: "PIC ****    *****")
        return cellCenter
    }
    
    func getImage()->UIImage{
        HCPrint(message: "PIC ****    *****")
        return cellImage
    }
    
    @objc func tapPic(){
        if let block = convertBlock {
            cellCenter = block(imgV.center)
            HCPrint(message: cellCenter)
        }
        cellImage = imgV.image!
        if let block = showPhotoBlock {
            let s = viewModel?.model?.imageList
            block([s!])
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
