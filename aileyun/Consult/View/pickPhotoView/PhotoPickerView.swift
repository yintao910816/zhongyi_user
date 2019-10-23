//
//  PhotoPickerView.swift
//  aileyun
//
//  Created by huchuang on 2017/7/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class PhotoPickerView: UIView {

    var maxNum = 3
    var lineNum = 3
    var margin_top : CGFloat = 5
    var itemSpace : CGFloat = 10
    
    var picBlock : (([UIImage])->())?
    
    var photoData = [UIImage]() 
    
    var collectionV : UICollectionView?
    
    let reuseIdentifierForCVcell = "collectionVcell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var itemWidth = (frame.size.width - CGFloat(lineNum - 1) * itemSpace) / CGFloat(lineNum)
        
        let itemHeight = frame.size.height - margin_top * 2
        
        itemWidth = itemWidth > itemHeight ? itemHeight : itemWidth
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(itemSpace)
        layout.minimumInteritemSpacing = CGFloat(itemSpace)
        layout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: margin_top, width: frame.size.width , height: frame.size.height - margin_top * 2), collectionViewLayout: layout)
        
        collectionV?.register(PhotoPickCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierForCVcell)
        
        collectionV?.bounces = false
        
        collectionV?.delegate = self
        collectionV?.dataSource = self
        
        collectionV?.backgroundColor = UIColor.white
        
        self.addSubview(collectionV!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension PhotoPickerView : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.count + 1 < maxNum ? photoData.count + 1 : maxNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierForCVcell, for: indexPath) as! PhotoPickCollectionViewCell
        cell.pickBlock = {
            let alertController = UIAlertController(title: "操作提示",
                                                    message: "请选择照片来源", preferredStyle: .alert)
            let sysPhotoAction = UIAlertAction(title: "相册", style: .default, handler: {[weak self](action)->() in
                self?.systemPic()
            })
            let takePhotoAction = UIAlertAction(title: "拍照", style: .default, handler: {[weak self](action)->() in
                self?.takePhoto()
            })
            alertController.addAction(sysPhotoAction)
            alertController.addAction(takePhotoAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        cell.deleteBlock = {[weak self]()in
            self?.photoData.remove(at: indexPath.row)
            if let block = self?.picBlock {
                block((self?.photoData)!)
            }
            collectionView.reloadData()
        }
        
        if indexPath.row == photoData.count{
            cell.img = nil
        }else{
            cell.img = photoData[indexPath.row]
        }
        
        return cell
    }
}



extension PhotoPickerView {
    func takePhoto(){
        if checkCameraPermissions() {
            let photoVC = UIImagePickerController()
            photoVC.sourceType = UIImagePickerControllerSourceType.camera
            photoVC.delegate = self
            photoVC.allowsEditing = true
            UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
        }else{
            authorizationForCamera(confirmBlock: { [weak self]()in
                DispatchQueue.main.async {
                    let photoVC = UIImagePickerController()
                    photoVC.sourceType = UIImagePickerControllerSourceType.camera
                    photoVC.delegate = self
                    photoVC.allowsEditing = true
                    UIApplication.shared.keyWindow?.rootViewController?.present(photoVC, animated: true, completion: nil)
                }
            })
            HCShowInfo(info: "请在手机设置-隐私-相机中开启权限")
        }
    }
    
    func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        systemPicVC.delegate = self
        systemPicVC.allowsEditing = true
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }
}

extension PhotoPickerView : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //UIImagePickerControllerEditedImage   UIImagePickerControllerOriginalImage
        let image  = info["UIImagePickerControllerEditedImage"] as! UIImage
        photoData.append(image)
        if let block = picBlock {
            block(photoData)
        }
        collectionV?.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
