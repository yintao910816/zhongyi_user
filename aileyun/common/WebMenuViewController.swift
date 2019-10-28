//
//  WebMenuViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/10.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class WebMenuViewController: UIViewController {

    weak var naviVC : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImageV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 114))
        
        let origImage = UIImage.init(named: "HC-jiaobiao-hui")
        let finalImage = origImage?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 20)
        backImageV.image = finalImage
        
        self.view.insertSubview(backImageV, at: 0)
        
        
        let shareBtn = menuButton()
        self.view.addSubview(shareBtn)
        shareBtn.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(1)
            make.right.equalTo(self.view).offset(-1)
            make.top.equalTo(self.view).offset(12)
            make.height.equalTo(50)
        }
        shareBtn.setTitle("开始分享", for: .normal)
        shareBtn.setTitleColor(kTextColor, for: .normal)
        shareBtn.setImage(UIImage.init(named: "我参与的课程"), for: .normal)
        shareBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        shareBtn.backgroundColor = UIColor.white
        
        //切左上和右上圆角 (UIRectCorner.topLeft | UIRectCorner.topRight)
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 148, height: 50), byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = CGRect.init(x: 0, y: 0, width: 148, height: 50)
        maskLayer.path = path.cgPath
        shareBtn.layer.mask = maskLayer
        
        shareBtn.addTarget(self, action: #selector(WebMenuViewController.click), for: .touchUpInside)
        
        let backToHomeBtn = menuButton()
        self.view.addSubview(backToHomeBtn)
        backToHomeBtn.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(1)
            make.right.equalTo(self.view).offset(-1)
            make.top.equalTo(shareBtn.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        backToHomeBtn.setTitle("回到首页", for: .normal)
        backToHomeBtn.setTitleColor(kTextColor, for: .normal)
        backToHomeBtn.setImage(UIImage.init(named: "我关注的"), for: .normal)
        backToHomeBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        backToHomeBtn.backgroundColor = UIColor.white
        
        let path1 = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 148, height: 50), byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer.init()
        maskLayer1.frame = CGRect.init(x: 0, y: 0, width: 148, height: 50)
        maskLayer1.path = path1.cgPath
        backToHomeBtn.layer.mask = maskLayer1
        
        backToHomeBtn.addTarget(self, action: #selector(WebMenuViewController.backToHome), for: .touchUpInside)
        
    }
    
    @objc func click(){
        self.dismiss(animated: false) { [weak self]()in
            self?.naviVC?.pushViewController(ShowShareViewController(), animated: true)
        }
    }
    
    @objc func backToHome(){
        self.dismiss(animated: false) { [weak self]()in
            self?.naviVC?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
