//
//  BaseViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/11/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var naviSepV : UIView = {
        let space = AppDelegate.shareIntance.space
        let d = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 43, width: SCREEN_WIDTH, height: 1))
        d.backgroundColor = kdivisionColor
        return d
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(naviSepV)
    }
    
    func notNeedSeparateV(){
        naviSepV.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = kLightTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : kLightTextColor]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
