//
//  CommonCallBack.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class CommonCallBack: NSObject {
    
   
    var code : NSInteger = 200
    var msg : String = ""
    var data : Any = ""

    override init() {
        super.init()
    }
    
    func success()->Bool{
        return code == 200
    }
    
    
}
