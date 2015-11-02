//
//  UIImageView+Extension.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit
///
/// 扩展 UIImageView
///
extension UIImageView {
    
    /// SDWebImage 隔离 sd_setImageWithURL:
    func yy_setImageWithURL(url: NSURL!) {
        sd_setImageWithURL(url)
    }
    
    /// SDWebImage 隔离 sd_setImageWithURL:placeholderImage:
    func yy_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!) {
        sd_setImageWithURL(url, placeholderImage: placeholder)
    }
}
