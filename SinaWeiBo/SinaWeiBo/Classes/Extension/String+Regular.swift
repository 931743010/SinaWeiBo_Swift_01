//
//  String+Regular.swift
//  正则表达式
//
//  Created by Arvin on 15/11/12.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import Foundation

extension String {
    
    func linkSource() -> String {
        // 匹配规则
        let pattern = ">(.*?)</a>"
        // 创建正则表达式
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配第一项
        let result = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        
        let count = result?.numberOfRanges ?? 0
        
        // 判断count是否 > 1
        if count > 1 {
            // 获取匹配的范围
            let range = result!.rangeAtIndex(1)
            let text = (self as NSString).substringWithRange(range)
            return "来自 "+text
            
        } else {
            return ""
        }
    }
}