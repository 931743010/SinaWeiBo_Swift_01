//
//  YYStatusBottomView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博自定义Cell的底部View

import UIKit

class YYStatusBottomView: UIView {
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        // 设置背景色
        backgroundColor = UIColor(white: 0.96, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(praiseButton)
        addSubview(separateLineViewOne)
        addSubview(separateLineViewTwo)
        
        // 水平平铺控件
        self.ff_HorizontalTile([forwardButton,commentButton,praiseButton], insets: UIEdgeInsetsZero)
        // 分隔线1
        separateLineViewOne.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: forwardButton, size: nil)
        // 分割线2
        separateLineViewTwo.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: commentButton, size: nil)
        
    }
    
    // MARK: - 懒加载
    /// 转发按钮
    private lazy var forwardButton: UIButton = UIButton(title: "转发", imageName: "timeline_icon_retweet", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    /// 评论按钮
    private lazy var commentButton: UIButton = UIButton(title: "评论", imageName: "timeline_icon_comment", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    /// 点赞按钮
    private lazy var praiseButton: UIButton = UIButton(title: "赞", imageName: "timeline_icon_unlike", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    
    /// 分隔线1
    private lazy var separateLineViewOne: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    /// 分隔线2
    private lazy var separateLineViewTwo: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
}
