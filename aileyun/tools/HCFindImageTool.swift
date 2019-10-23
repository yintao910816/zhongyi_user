//
//  HCFindImageTool.swift
//  aileyun
//
//  Created by huchuang on 2017/9/14.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCFindImageTool: NSObject {
    // 设计成单例
    static let shareIntance : HCFindImageTool = {
        let tools = HCFindImageTool()
        return tools
    }()
    
    
    public func HC_setImage(key : String, url : String ,imgV : UIImageView){
        
        let preUrl = UserDefaults.standard.value(forKey: key) as? String
        guard preUrl != nil else {
            downloadImage(key: key, url: url, imgV: imgV)
            return
        }
        
        if preUrl! == url {
            if let img = findImageFromLocal(url: url) {
                imgV.image = img
            }else{
                UserDefaults.standard.removeObject(forKey: key)
                downloadImage(key: key, url: url, imgV: imgV)
            }
        }else{
            downloadImage(key: key, url: url, imgV: imgV)
        }
    }
    
    private func findImageFromLocal(url : String)->UIImage?{
        
        let path = getFilePathStr(url: url)
        
        if FileManager.default.fileExists(atPath: path) {
            if let img = UIImage.init(contentsOfFile: path){
                return img
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    private func downloadImage(key : String, url : String, imgV : UIImageView){
        
        DispatchQueue.global().async {[weak self]()in
            let tempurl = URL.init(string: url)
            let session = URLSession.shared
            let task = session.dataTask(with: tempurl!) {(data, res, error) in
                if let data = data{
                    if let img = UIImage.init(data: data){
                        DispatchQueue.main.async {
                            imgV.image = img
                        }
                        self?.storeImage(url: url, key: key, img: img)
                    }else{
                        HCPrint(message: "data转image出错")
                    }
                }else{
                    HCPrint(message: "data下载出错")
                }
            }
            task.resume()
        }
        
    }
    
    private func storeImage(url : String, key : String, img : UIImage){
        if let data = UIImagePNGRepresentation(img) as NSData?{
            let path = getFilePathStr(url: url)
            DispatchQueue.global().async {
                let isSuc = data.write(toFile: path, atomically: true)
                if isSuc{
                    UserDefaults.standard.set(url, forKey: key)
                }else{
                    HCPrint(message: "图片缓存失败")
                }
            }
        }else{
            HCPrint(message: "图片缓存失败")
        }
        
    }
    
    
    private func getFilePathStr(url : String)->String{
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                            FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        let suffixName = url.components(separatedBy: "/").last!
        
        let path = cachePath + "/" + suffixName
        
        return path
    }
    

}
