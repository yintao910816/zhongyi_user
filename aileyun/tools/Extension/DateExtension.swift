//
//  NSDate-Extension.swift
//  04-时间的处理
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import Foundation


extension Date {
    
    static func createTimeWithString(_ number : NSNumber) -> String {
        // 1.创建时间格式化对象
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en")
//        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // 2.获取时间
//        guard let createDate = fmt.date(from: timeString) else {
//            return ""
//        }
        
        let milliseconds = number.int64Value
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
           
        
        // 3.获取当前时间
        let nowDate = Date()
        
        // 4.获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.判断时间显示的格式
        // 5.1.1分钟之内
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2.一个小时内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 5.3.一天之内
        if interval < 60 * 60 * 24 {
            return "\(interval / 60 / 60)小时前"
        }
        
        // 6.其他时间的显示
        // 6.1.创建日期对象
        let calendar = Calendar.current
        
        // 6.2.昨天的显示
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "HH:mm"
            let timeString = fmt.string(from: createDate)
            return "昨天 \(timeString)"
        }
        
        // 6.3.一年之内
        let cpns = (calendar as NSCalendar).components(NSCalendar.Unit.year, from: createDate, to: nowDate, options: [])
        if cpns.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.string(from: createDate)
            return timeString
        }
        
        // 6.4.一年以上
        fmt.dateFormat = "yyyy-MM-dd"
        let timeString = fmt.string(from: createDate)
        
        return timeString
    }
    
    
    static func isWithin24hours(_ number : NSNumber) -> Bool{
        
        let milliseconds = number.intValue
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
        // 3.获取当前时间
        let nowDate = Date()
        
        // 4.获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.3天之内 60 * 60 * 24 * 10
        if interval < 86400 {
            return true
        }else{
            return false
        }
    }
    
    func converteYYYYMMddHHmmss()->String{
        let format = DateFormatter.init()
        format.dateFormat = "YYYYMMddHHmmss"
        return format.string(from: self)
    }
    
    func converteYYYYMMdd()->String{
        let format = DateFormatter.init()
        format.dateFormat = "YYYY-MM-dd"
        return format.string(from: self)
    }
}
