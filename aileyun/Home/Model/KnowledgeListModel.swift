//
//  KnowledgeListModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/15.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class KnowledgeListModel: NSObject, HandyJSON {
    
    var name : String?
    var value : String?
    var detailList: [KnowledgeModel] = []
    var id : String?
    var order : NSNumber?
    
//    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["detailList" : KnowledgeModel.classForCoder()]
//    }

    required override init() {
        
    }
}
