//
//  UIColor+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/30.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

// 扩展UIColor
extension UIColor {
    
    /// 返回随机颜色
    class func randomColor() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1)
    }
    // 产生随机值
    private class func randomValue() -> CGFloat {
        return CGFloat (arc4random_uniform(256)) / 255
    }
    
}
