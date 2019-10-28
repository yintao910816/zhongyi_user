//
//  PhotoPickCollectionViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class PhotoPickCollectionViewCell: UICollectionViewCell {
    var pickBlock : blankBlock?
    var deleteBlock : blankBlock?
    
    lazy var imgV = UIImageView()
    lazy var pickerBtn = UIButton()
    lazy var deleteBtn = UIButton()
    
    var img : UIImage?{
        didSet{
            if img != nil {
                pickerBtn.isHidden = true
            }else{
                pickerBtn.isHidden = false
            }
            imgV.image = img
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgV)
        imgV.frame = self.bounds
        
        self.addSubview(deleteBtn)
        deleteBtn.snp.updateConstraints { (make) in
            make.right.top.equalTo(self)
            make.width.height.equalTo(20)
        }
        deleteBtn.addTarget(self, action: #selector(PhotoPickCollectionViewCell.deleteAction), for: .touchUpInside)
        deleteBtn.backgroundColor = UIColor.red
        deleteBtn.setTitle("-", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.init(name: kBoldFont, size: 15)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.layer.cornerRadius = 10
        
        self.addSubview(pickerBtn)
        pickerBtn.frame = self.bounds
        pickerBtn.setImage(UIImage.init(named: "加号"), for: .normal)
        pickerBtn.addTarget(self, action: #selector(PhotoPickCollectionViewCell.pickerAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func deleteAction(){
        if deleteBlock != nil {
            deleteBlock!()
        }
    }
    
    @objc func pickerAction(){
        if pickBlock != nil{
            pickBlock!()
        }
    }
}
