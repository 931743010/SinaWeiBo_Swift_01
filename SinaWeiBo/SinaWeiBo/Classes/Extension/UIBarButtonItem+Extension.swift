//
//  UIBarButtonItem+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/30.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    ///
    /// 在扩展中只能是便利构造方法(代替下面方法)
    ///
    convenience init(imageName: String) {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        self.init(customView: button)
    }
    
    ///
    /// 类方法,返回图片按钮(使用上面方法)
    ///
    class func navigationItem(imageName: String) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
}
