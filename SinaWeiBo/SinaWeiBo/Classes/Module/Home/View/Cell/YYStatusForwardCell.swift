//
//  YYStatusForwardCell.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/2.
//  Copyright © 2015年 Arvin. All rights reserved.

// 转发微博的cell

import UIKit

class YYStatusForwardCell: YYStatusCell {
    
    /// 重写父类属性,要加override关键字,实现属性监视器
    /// 会先调用父类的属性监视器,再调用子类的重写属性的属性监视器
    override var status: YYStatus? {
        didSet {
            // print("子类属性监视器")
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            // 设置被转发微博的内容
            forwardLabel.text = "@\(name):\(text)"
            forwardLabel.sizeToFit()
        }
    }
    
    /// 重写父类 prepareUI()方法
    override func prepareUI() {
        // 必须先调用父类方法初始化
        super.prepareUI()
        
        // 将转发微博的背景按钮插入到微博配图的底层
        contentView.insertSubview(bkgButton, belowSubview: pictureView)
        // 添加被转发微博的内容标签到contentView
        contentView.addSubview(forwardLabel)
        
        // 转发微博的背景按钮约束
        // 参照微博的内容标签的左下角
        bkgButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -8, y: 8))
        // 参照微博的底部View的右上角
        bkgButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        
        // 被转发微博的Label约束
        // 参照微博的背景按钮的左上角
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: bkgButton, size: nil, offset: CGPoint(x: 8, y: 8))
        // 参照自己的宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: forwardLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        
        // 被转发微博的配图约束
        let constraint = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: UIScreen.width() - 2 * 8, height: 0), offset: CGPoint(x: 0, y: 8))
        
        // 获取微博配图的宽/高
        pictureViewWidthCons = pictureView.ff_Constraint(constraint, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.ff_Constraint(constraint, attribute: NSLayoutAttribute.Height)
        
    }
    
    
    // MARK: - 懒加载
    /// 被转发微博的背景按钮
    private lazy var bkgButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return button
    }()
    
    /// 被转发微博的文本标签
    private lazy var forwardLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.darkGrayColor())
        //label.text = "我是测试数据"
        label.numberOfLines = 0
        return label
    }()
    
}
