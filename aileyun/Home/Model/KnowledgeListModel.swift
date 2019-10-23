//
//  KnowledgeListModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/15.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class KnowledgeListModel: NSObject {
    
    var name : String?
    var value : String?
    var detailList : NSArray?
    var id : String?
    var order : NSNumber?
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["detailList" : KnowledgeModel.classForCoder()]
    }

    
}
