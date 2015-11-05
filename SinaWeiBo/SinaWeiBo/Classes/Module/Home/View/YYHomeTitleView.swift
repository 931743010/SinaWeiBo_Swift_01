//
//  YYHomeTitleView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/31.
//  Copyright © 2015年 Arvin. All rights reserved.

// 导航栏中间标题按钮

import UIKit

class YYHomeTitleViewButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 改变箭头图片的位置 X 值
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)! + 5
    }
}


class YYBottomViewButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layoutSubviews:\(imageView!.frame)")
//        imageView?.frame.origin.x = (titleLabel?.frame.width)! + 2
//        imageView!.frame.origin.x = 0
//        titleLabel?.frame.origin.x = imageView!.frame.width + 20
    }
}