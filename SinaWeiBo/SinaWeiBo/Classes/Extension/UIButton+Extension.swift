//
//  UIButton+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit
///
/// 扩展 UIButton
///
extension UIButton {
    /// 便利构造函数(方式1)
    convenience init(title: String, imageName: String, selectedHighligtedImage: String, titleColor: UIColor, fontSize: CGFloat) {
        // 先调用本类指定构造函数
        self.init()
        setTitle(title, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: selectedHighligtedImage), forState: UIControlState.Highlighted)
        
    }
    
    /* 便利构造函数(方式2)
    convenience init(title: String, imageName: String, titleColor: UIColor = UIColor.darkGrayColor(), fontSize: CGFloat = 12) {
        self.init()
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }*/
    
}
