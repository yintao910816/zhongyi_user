//
//  BindedModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/11.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BindedModel: NSObject {
    
    //    hospitalId = 15;
    //    hospitalName = "\U70df\U53f0\U6bd3\U749c\U9876\U533b\U9662\U751f\U6b96\U4e2d\U5fc3";
    //    idNo = 370611198204200365;
    //    patientId = 70;
    //    realName = "\U6811\U6811";
    //    visitCard = 3706020001000068765;

    
    var hospitalId : NSNumber?
    var hospitalName : String?
    var idNo : String?
    var patientId : NSNumber?
    var realName : String?
    var visitCard : String?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}
