//
//  UIImage+Extension.swift
//  照片选择器
//
//  Created by Arvin on 15/11/10.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     - returns: 返回缩放后的图片
     */
    func scaleImage() -> UIImage {
        
        let newWidth: CGFloat = 300
        // 如果原来的宽度小于300, 直接返回
        if size.width < newWidth {
            return self
        }
        
        // 缩放比例
        // newHeight / newWidth = 原来的高度 / 原来的宽度
        let newHeight = newWidth * size.height / size.width
        
        let newSize = CGSizeMake(newWidth, newHeight)
        
        // 开启图片的上下文
        UIGraphicsBeginImageContext(newSize)
        
        // 开始绘制图片,将当前图片绘制到rect上
        drawInRect(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
        // 从上下文获取绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        // 返回缩放后的图片
        return newImage
        
    }
    
}
