//
//  YYStatusNormalCell.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/2.
//  Copyright © 2015年 Arvin. All rights reserved.

// 原创微博的cell的配图约束

import UIKit

// 因为转发微博也需要设置配图的约束,不能在YYStatusCell的prepareUI()方法中设置,那样会影响到转发微博的配图的约束, 所以创建子类YYStatusNormalCell继承YYStatusCell来添加配图的约束
class YYStatusNormalCell: YYStatusCell {
    // 重写 prepareUI()方法
    override func prepareUI() {
        // 先调用父类方法初始化
        super.prepareUI()
        // 原创微博的配图约束
        let constraint = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 0, height: 0), offset: CGPoint(x: 0, y: 8))
        // 获取微博配图的宽/高
        pictureViewWidthCons = pictureView.ff_Constraint(constraint, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.ff_Constraint(constraint, attribute: NSLayoutAttribute.Height)
    }
}
