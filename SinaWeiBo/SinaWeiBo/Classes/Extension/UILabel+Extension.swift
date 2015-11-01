//
//  UILabel+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

extension UILabel {
    /// 便利构造函数
    convenience init(fontSize: CGFloat,textColor: UIColor) {
        self.init()
        // 字体颜色
        self.textColor = textColor
        // 字体大小
        font = UIFont.systemFontOfSize(fontSize)
    }
}
