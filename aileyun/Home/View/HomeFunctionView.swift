//
//  HomeFunctionView.swift
//  aileyun
//
//  Created by huchuang on 2017/8/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeFunctionView: UIView {
    
    weak var naviVC : UINavigationController?
    
    var modelArr : [HomeFunctionModel]?{
        didSet{
            collectionV.reloadData()
            updateSize((modelArr?.count)!)
        }
    }

    lazy var collectionV : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: FuncSizeWidth, height: FuncSizeWidth)
        layout.scrollDirection = .vertical
        
        let collectV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: FuncSizeWidth), collectionViewLayout: layout)
        
        collectV.delegate = self
        collectV.dataSource = self
        
        collectV.backgroundColor = UIColor.white
        
        return collectV
        
    }()
    
    let collectionReuseI = "collectionReuseI"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionV.register(FunctionCollectionViewCell.self, forCellWithReuseIdentifier: collectionReuseI)
        self.addSubview(collectionV)
    }
    
    func updateSize(_ count : NSInteger){
        let layer = (count - 1) / 4 + 1
        HCPrint(message: layer)
        collectionV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: FuncSizeWidth * CGFloat(layer))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func actionWithModel(model : HomeFunctionModel){
        let name = model.name
        
        if let url = model.url {
            if url.contains("reservation"){
                register(urlS: url)
            }else if url == "#"{
                if let name = name{
                    switch name {
                    case "绑定机构":
                        bind()
                    default:
                        HCPrint(message: name + " 没有url")
                    }
                }else{
                    HCShowError(info: "出错：name为空")
                }
            }else{
                if let needBind = model.isBind {
                    if needBind.intValue == 1 {
                        guard UserManager.shareIntance.BindedModel != nil else{
                            SVProgressHUD.show()
                            HttpRequestManager.shareIntance.HC_checkHospitalBind(patientId: (UserManager.shareIntance.HCUser!.id?.intValue)!) {[weak self](success, model) in
                                SVProgressHUD.dismiss()
                                if success == true {
                                    //已绑定
                                    let webVC = WebViewController()
                                    webVC.url = url
                                    self?.naviVC?.pushViewController(webVC, animated: true)
                                }else{
                                    self?.naviVC?.pushViewController(BindHospitalViewController(), animated: true)
                                    showAlert(title: "提醒", message: "此功能需要绑定就诊卡")
                                }
                            }
                            return
                        }
                    }
                    let webVC = WebViewController()
                    webVC.url = url
                    naviVC?.pushViewController(webVC, animated: true)
                }
            }
        }else{
          HCShowError(info: "功能暂不开放")
        }
    }
    
    //预约
    func register(urlS : String){
        
        if UserManager.shareIntance.BindedModel != nil {
            //已绑定
            registerH5(urlS: urlS)
        }else{
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_checkHospitalBind(patientId: (UserManager.shareIntance.HCUser!.id?.intValue)!) {[weak self](success, model) in
                SVProgressHUD.dismiss()
                if success == true {
                    //已绑定
                    self?.registerH5(urlS: urlS)
                }else{
                    self?.naviVC?.pushViewController(BindHospitalViewController(), animated: true)
                    showAlert(title: "提醒", message: "还未绑定生殖中心")
                }
            }
        }
    }
    
    
    func registerH5(urlS : String){
        let webVC = WebViewController()
        webVC.url = urlS
        naviVC?.pushViewController(webVC, animated: true)
    }
    

    
    //绑定生殖中心
    func bind(){
        if UserManager.shareIntance.BindedModel != nil {
            let bindedVC = BindedViewController()
            bindedVC.bindedM = UserManager.shareIntance.BindedModel
            naviVC?.pushViewController(bindedVC, animated: true)
        }else{
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_checkHospitalBind(patientId: (UserManager.shareIntance.HCUser!.id?.intValue)!) {[weak self](success, model) in
                SVProgressHUD.dismiss()
                if success == true {
                    let bindedVC = BindedViewController()
                    bindedVC.bindedM = model
                    self?.naviVC?.pushViewController(bindedVC, animated: true)
                }else{
                    self?.naviVC?.pushViewController(BindHospitalViewController(), animated: true)
                }
            }
        }

    }
    

}




extension HomeFunctionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: FuncSizeWidth, height: FuncSizeWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseI, for: indexPath) as! FunctionCollectionViewCell
        cell.model = modelArr?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelArr?[indexPath.row]
        if let model = model {
            actionWithModel(model: model)
        }
    }
}
