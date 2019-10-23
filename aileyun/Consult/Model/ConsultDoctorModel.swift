//
//  ConsultDoctorModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/13.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultDoctorModel: NSObject {


    var doctorId : String?
    var doctorName : String?
    var doctorProduce : String?
    var goodSkill : String?
    var hospitalName : String?
    
    var judgeCount : NSNumber?
    var judgeScore : NSNumber?
    var judgeStarCount : NSNumber?
    var judgeTotalCount : NSNumber?
    
    var picture : String?
    var position : String?
    var replyCounts : String?
    var price : String?
    
    //咨询过吗
    var isConsulted : Bool = false
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
