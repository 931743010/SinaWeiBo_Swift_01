//
//  UIScreen+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// 返回屏幕宽度
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
        
    /// 返回屏幕高度
    class func height() -> CGFloat {
       return UIScreen.mainScreen().bounds.height
    }
    
}
