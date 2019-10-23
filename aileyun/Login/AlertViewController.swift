//
//  AlertViewController.swift
//  labMonitor
//
//  Created by huchuang on 2018/3/29.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class AlertViewController: UIViewController {
    
    
    lazy var contV : UIView = {
        let c = UIView()
        c.backgroundColor = UIColor.white
        c.layer.cornerRadius = 5
        c.clipsToBounds = true
        return c
    }()
    
    lazy var titleL : UILabel = {
        let t = UILabel()
        t.textAlignment = .center
        t.textColor = kTextColor
        t.font = UIFont.init(name: kReguleFont, size: kTextSize + 4)
        return t
    }()
    
    lazy var contentL : UILabel = {
        let c = UILabel()
        c.numberOfLines = 5
        c.textColor = kLightTextColor
        c.font = UIFont.init(name: kReguleFont, size: kTextSize)
        return c
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }
    
    
    func initUI(){
        self.view.backgroundColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.8)
        
        self.view.addSubview(contV)
        contV.snp.updateConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.centerY.equalTo(self.view).offset(-44)
        }
        
        contV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(contV).offset(15)
            make.left.right.equalTo(contV)
        }
        
        contV.addSubview(contentL)
        contentL.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.left.equalTo(contV).offset(15)
            make.right.equalTo(contV).offset(-15)
        }
        
        let confirmBtn = UIButton()
        contV.addSubview(confirmBtn)
        confirmBtn.snp.updateConstraints { (make) in
            make.top.equalTo(contentL.snp.bottom).offset(30)
            make.left.equalTo(contV).offset(30)
            make.right.equalTo(contV).offset(-30)
            make.height.equalTo(40)
            make.bottom.equalTo(contV).offset(-15)
        }
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.setTitle("马上进入", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = kDefaultThemeColor
        
        confirmBtn.addTarget(self, action: #selector(AlertViewController.click), for: .touchUpInside)
        
        let imgV = UIImageView.init(image: UIImage.init(named: "closeAlert"))
        self.view.addSubview(imgV)
        imgV.snp.updateConstraints { (make) in
            make.top.equalTo(contV.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { (bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func click(){
        HCPrint(message: "click")
    }

}
