//
//  YYHomeTitleView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/31.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYHomeTitleView: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 改变箭头图片的位置 X 值
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)! + 5
    }
}
