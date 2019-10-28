//
//  treasuryTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/6/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class treasuryTableViewCell: UITableViewCell {
    
    var model : HCCircleModel?{
        didSet{
            if let heads = model?.headPhoto{
                headImg.HC_setImageFromURL(urlS: heads, placeHolder: "默认头像")
            }else{
                headImg.image = UIImage.init(named: "默认头像")
            }
            
            nameL.text = model?.nickName
            timeL.text = model?.createTime
            readL.text = model?.viewCount
            titleL.text = model?.title
            contentL.text = model?.brief
            
            commentL.text = model?.replayCount
            praiseL.text = String.init(format: "%d", (model?.likeCount?.intValue)!)
            
            if model?.imgUrls != nil {
                picArr = convertToTableData(arr: model?.imgUrls as! [String])
            }else{
                updatePicConstraint(hidden: true)
            }
            
            if model?.labelNames != nil {
                tagNames = convertToTableData(arr: model?.labelNames as! [String])
            }
        }
    }
    
    var picArr : [String]?{
        didSet{
            picColV.reloadData()
            if picArr?.count == 0{
                updatePicConstraint(hidden: true)
            }else{
                updatePicConstraint(hidden: false)
            }
        }
    }
    
    var tagNames : [String]?{
        didSet{
            fromColV.reloadData()
        }
    }
    
    let headImg = UIImageView()
    let nameL = UILabel()
    let timeL = UILabel()
    let readL = UILabel()
    
    let titleL = UILabel()
    let contentL = UILabel()
    
    let picColReuseI = "picColReuseI"
    
    lazy var picColV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize.init(width: KImgWidth, height: KImgWidth)
        layout.scrollDirection = .horizontal
        
        let collectV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH , height: KImgWidth), collectionViewLayout: layout)
        
        collectV.delegate = self
        collectV.dataSource = self
        collectV.backgroundColor = UIColor.white
        
        return collectV
    }()
    
    let TagColReuseI = "TagColReuseI"
    
    let fromColVConV = UIView()
    
    lazy var fromColV : UICollectionView = {
        let layout = EqualSpaceFlowLayout.init()
        layout.itemSize = CGSize.init(width: 44, height: 18)
        
        let collectV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 100 , height: TagLabelHeight), collectionViewLayout: layout)
        
        collectV.delegate = self
        collectV.dataSource = self
        collectV.backgroundColor = UIColor.white
        
        return collectV
    }()
    
    let commentL = UILabel()
    let praiseL = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func convertToTableData(arr : [String])->[String]{
        var tempArr = [String]()
        for i in arr{
            guard i != "" else {
                continue
            }
            tempArr.append(i)
        }
        return tempArr
    }
    
    func updatePicConstraint(hidden : Bool){
        picColV.isHidden = hidden
        if hidden {
            fromColVConV.snp.updateConstraints { (make) in
                make.top.equalTo(contentL.snp.bottom).offset(10)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(SCREEN_WIDTH - 100)
                make.height.equalTo(TagLabelHeight)
            }
        }else{
            fromColVConV.snp.updateConstraints { (make) in
                make.top.equalTo(contentL.snp.bottom).offset(30 + KImgWidth)
                make.left.equalTo(self).offset(20)
                make.width.equalTo(SCREEN_WIDTH - 100)
                make.height.equalTo(TagLabelHeight)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        self.addSubview(headImg)
        headImg.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(20)
            make.width.height.equalTo(35)
        }
        headImg.layer.cornerRadius = 17
        headImg.clipsToBounds = true
        
        nameL.font = UIFont.init(name: kReguleFont, size: 14)
        nameL.textColor = kTextColor
        self.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.top.equalTo(headImg)
            make.left.equalTo(headImg.snp.right).offset(12)
            make.height.equalTo(18)
        }
        
        timeL.font = UIFont.init(name: kReguleFont, size: 12)
        timeL.textColor = kLightTextColor
        self.addSubview(timeL)
        timeL.snp.updateConstraints { (make) in
            make.top.equalTo(nameL.snp.bottom)
            make.left.height.width.equalTo(nameL)
        }
        
        readL.textColor = kNumberColor
        readL.textAlignment = NSTextAlignment.center
        readL.font = UIFont.init(name: kReguleFont, size: 12)
        self.addSubview(readL)
        readL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(headImg)
            make.width.equalTo(30)
        }
        
        let readIV = UIImageView()
        readIV.image = UIImage.init(named: "浏览量")
        readIV.contentMode = .scaleAspectFit
        self.addSubview(readIV)
        readIV.snp.updateConstraints { (make) in
            make.right.equalTo(readL.snp.left)
            make.centerY.equalTo(readL)
            make.width.height.equalTo(14)
        }
        
        titleL.font = UIFont.init(name: kReguleFont, size: 16)
        titleL.textColor = kTextColor
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(headImg.snp.bottom).offset(15)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(20)
        }
        
        contentL.font = UIFont.init(name: kReguleFont, size: 14)
        contentL.textColor = kLightTextColor
        contentL.numberOfLines = 0
        self.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        
        //图片展示
        self.addSubview(picColV)
        picColV.snp.updateConstraints { (make) in
            make.top.equalTo(contentL.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(KImgWidth)
        }
        picColV.register(groupCollectionViewCell.self, forCellWithReuseIdentifier: picColReuseI)
        
        self.addSubview(fromColVConV)
        fromColVConV.snp.updateConstraints { (make) in
            make.top.equalTo(contentL.snp.bottom).offset(30 + KImgWidth)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 100)
            make.height.equalTo(TagLabelHeight)
        }
        
        fromColVConV.addSubview(fromColV)
        fromColV.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagColReuseI)
        
        
        praiseL.textColor = kNumberColor
        praiseL.textAlignment = NSTextAlignment.center
        praiseL.font = UIFont.init(name: kReguleFont, size: 12)
        self.addSubview(praiseL)
        praiseL.snp.updateConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(fromColVConV)
            make.height.equalTo(20)
            make.bottom.equalTo(self).offset(-10)
        }
        
        let praiseIV = UIImageView()
        praiseIV.image = UIImage.init(named: "点赞量")
        praiseIV.contentMode = .scaleAspectFit
        self.addSubview(praiseIV)
        praiseIV.snp.updateConstraints { (make) in
            make.right.equalTo(praiseL.snp.left)
            make.centerY.equalTo(praiseL)
            make.width.height.equalTo(14)
        }
        
        commentL.textColor = kNumberColor
        commentL.textAlignment = NSTextAlignment.center
        commentL.font = UIFont.init(name: kReguleFont, size: 12)
        self.addSubview(commentL)
        commentL.snp.updateConstraints { (make) in
            make.right.equalTo(praiseIV.snp.left).offset(-10)
            make.centerY.equalTo(praiseL)
            make.height.equalTo(20)
        }
        
        let commentIV = UIImageView()
        commentIV.image = UIImage.init(named: "评论量")
        commentIV.contentMode = .scaleAspectFit
        self.addSubview(commentIV)
        commentIV.snp.updateConstraints { (make) in
            make.right.equalTo(commentL.snp.left)
            make.centerY.equalTo(praiseL)
            make.width.height.equalTo(14)
        }
    }

}

extension treasuryTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == picColV {
            if let count = picArr?.count {
                return count > 3 ? 3 : count
            }else{
                return 0
            }
        }else{
            return tagNames?.count ?? 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == picColV {
//            return CGSize.init(width: KImgWidth, height: KImgWidth)
//        }else{
//            return CGSize.init(width: 44, height: 16)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == picColV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picColReuseI, for: indexPath) as! groupCollectionViewCell
            cell.urlStr = picArr?[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagColReuseI, for: indexPath) as! TagCollectionViewCell
            cell.infoL.text = tagNames?[indexPath.row]
            return cell
        }
    }
    
}
