//
//  TreasuryListModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/15.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class TreasuryListModel: NSObject, HandyJSON {
    
    var list : [KnowledgeModel] = []
    var pageidx : NSNumber?
    var total : NSNumber?
    var pagecount : NSNumber?
    
    
//    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["list" : KnowledgeModel.classForCoder()]
//    }

    required override init() {
        
    }
}
