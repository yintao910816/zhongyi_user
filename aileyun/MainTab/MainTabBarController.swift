//
//  MainTabBarController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class MainTabBarController: UITabBarController {
    
    override var childForStatusBarStyle: UIViewController?{
        get {
            return self.selectedViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(childControllerName: "HomeTableViewController", title: "首页", normalImage: "Home")
        addChildViewController(childControllerName: "ConsultViewController", title: "问医生", normalImage: "Consult")
//        addChildViewController(childControllerName: "GulouNaviViewController", title: "导航", normalImage: "navi")
        addChildViewController(childControllerName: "GroupViewController", title: "圈子", normalImage: "Group")
        addChildViewController(childControllerName: "UserTableViewController", title: "我", normalImage: "User")

        self.tabBar.tintColor = kDefaultThemeColor
        self.tabBar.isTranslucent = false
        
        globelSetting()
        
    }

    
    func globelSetting(){
        let tempData = UserDefaults.standard.value(forKey: kBindDic)
        if tempData != nil {
            let dic = tempData as! [String : Any]
//            UserManager.shareIntance.BindedModel = BindedModel.init(dic)
            UserManager.shareIntance.BindedModel = JSONDeserializer<BindedModel>.deserializeFrom(dict: dic)
        }
        
        let tempData2 = UserDefaults.standard.value(forKey: kUserInfoDic)
        if tempData2 != nil {
            let dic = tempData2 as! [String : Any]
//            UserManager.shareIntance.HCUserInfo = HCUserInfoModel.init(dic)
            UserManager.shareIntance.HCUserInfo = JSONDeserializer<HCUserInfoModel>.deserializeFrom(dict: dic)
        }
    }
    
    private func addChildViewController(childControllerName : String, title : String, normalImage : String) {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        HCPrint(message: cls)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            return
        }
        
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        // 设置TabBar和Nav的标题
        childController.title = title
        
//        childController.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        childController.tabBarItem.selectedImage = UIImage(named: normalImage + "_HL")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        childController.tabBarItem.image = UIImage(named: normalImage)
        childController.tabBarItem.selectedImage = UIImage(named: normalImage + "_HL")
        
        // 包装导航控制器
        let nav = BaseNavigationController(rootViewController: childController)
        self.addChild(nav)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
