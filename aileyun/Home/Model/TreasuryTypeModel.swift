//
//  TreasuryTypeModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/15.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class TreasuryTypeModel: NSObject {

    var name : String?
    var value : String?
    var id : String?
    var order : NSNumber?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    //  + "\()"
    override var description: String {
        get{
            return "name\(name)" + " value\(value)" + " id\(id)" + " order\(order)"
        }
    }

}
