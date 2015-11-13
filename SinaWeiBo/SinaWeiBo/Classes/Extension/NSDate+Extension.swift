//
//  NSDate+Extension.swift
//  NSDate(日期处理)
//
//  Created by Arvin on 15/11/11.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import Foundation

extension NSDate {
    
    class func sinaStringToDate(date: String) -> NSDate {
        
        // 格式化日期
        let dfmt = NSDateFormatter()
        
        // 指定区域
        dfmt.locale = NSLocale(localeIdentifier: "cn")
        
        // 自定义日期格式
        dfmt.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        // 转换成系统的NSDate
        let date = dfmt.dateFromString(date)
        
        return date ?? NSDate()
        
    }
    
    
    func sinaDateDescription() -> String {
        // 创建日历
        let calendar = NSCalendar.currentCalendar()
        
        // 判断是否是今天
        if calendar.isDateInToday(self) {
            
            // 获取系统当前日期和self比较,相差多少秒
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            // 一分钟内
            if delta < 60 {
                return "刚刚"
                
                // 一小时内
            } else if delta < 60 * 60 {
                return "\(delta / 60)分钟前"
                
                // 一天内
            } else {
                return "\(delta / 60 / 60)小时前"
            }
        }
        
        var fmt = ""
        
        // 昨天
        if calendar.isDateInYesterday(self) {
            fmt = "昨天 HH:mm"
        } else {
            // 判断是一年内,还是更早期
            let result = calendar.compareDate(self, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.Year)
            // 表示同一年
            if result == NSComparisonResult.OrderedSame {
                // 一年内
                fmt = "MM-dd HH:mm"
            } else {
                // 一年前
                fmt = "yyyy-MM-dd HH:mm"
            }
            
        }
        // 格式化日期
        let dfmt = NSDateFormatter()
        // 指定格式
        dfmt.dateFormat = fmt
        // 指定区域
        dfmt.locale = NSLocale(localeIdentifier: "cn")
        // 将系统的时间转成指定格式的字符串
        let dateStr = dfmt.stringFromDate(self)
        return dateStr
    }
    
}

