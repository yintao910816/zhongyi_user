//
//  HC_consultCellModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HC_consultCellModel: NSObject {
    var type : String?
    
    var headImg : String?
    var content : String?
    
    var createTime : NSNumber?{
        didSet{
            let num = createTime?.doubleValue
            let date = Date.init(timeIntervalSince1970: num! / 1000)
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            createT = formatter.string(from: date)
        }
    }
    
    var createT : String?
    
    var imageList : String?
    
    //来自谁？
    var isDoctor : String?


    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
