//
//  KnowledgeModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/15.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class KnowledgeModel: NSObject {
    
    var PAGE_URL : String?
    var TREATMENT : String?
    var AUTHOR : String?
    var DIGEST : String?
    var CREATE_TIME : String?
    
    var SICK : String?
    var MEDIA_ID : String?
    var ID : String?
    var COVER_PIC : String?
    var TOP_TIME : String?
    
    var KEYWORD : String?
    var TREATMENT_PLAN : String?
    var TITLE : String?
    var KNOWLEDGE_TYPE : String?
    
    override var description: String {
        get{
            return "PAGE_URL\(PAGE_URL)" + " TREATMENT\(TREATMENT)" + " AUTHOR\(AUTHOR)" + " DIGEST\(DIGEST)" + " CREATE_TIME\(CREATE_TIME)" + " SICK\(SICK)" + " MEDIA_ID\(MEDIA_ID)" + " D\(ID)" + " COVER_PIC\(COVER_PIC)" + " TOP_TIME\(TOP_TIME)" + " KEYWORD\(KEYWORD)" + " TREATMENT_PLAN\(TREATMENT_PLAN)" + " TITLE\(TITLE)" + " KNOWLEDGE_TYPE\(KNOWLEDGE_TYPE)"
        }
    }

}
