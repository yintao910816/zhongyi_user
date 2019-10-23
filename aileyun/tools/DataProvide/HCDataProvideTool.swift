//
//  HCDataProvideTool.swift
//  aileyun
//
//  Created by huchuang on 2017/9/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCDataProvideTool: NSObject {
    
    dynamic var circleData : [HCCircleModel]?
    
    // 设计成单例
    static let shareIntance : HCDataProvideTool = {
        let tools = HCDataProvideTool()
        return tools
    }()
    
    func requestCircleData(){
        HttpRequestManager.shareIntance.HC_findLastestTopics(callback: { [weak self](success, arr, msg) in
            if success == true {
                self?.circleData = arr!
            }else{
                HCPrint(message: msg)
            }
        })
    }
    

}
