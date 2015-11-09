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
        //backgroundColor = UIColor.randomColor()
        //backgroundColor = UIColor(white: 0.98, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(praiseButton)
        addSubview(lineViewOne)
        addSubview(lineViewTwo)
        addSubview(separateLineViewOne)
        addSubview(separateLineViewTwo)
        
        // 水平平铺控件
        self.ff_HorizontalTile([forwardButton,commentButton,praiseButton], insets: UIEdgeInsetsZero)
        
        // 垂直分隔线1
        separateLineViewOne.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: forwardButton, size: nil)
        
        // 垂直分割线2
        separateLineViewTwo.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: commentButton, size: nil)
        
        // 水平分隔线1
        lineViewOne.ff_AlignVertical(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 0.5))
        
        // 水平分隔线2
        lineViewTwo.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 0.5))
        
        //forwardButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    }
    
    
    // MARK: - 懒加载
    /// 转发按钮
    private lazy var forwardButton: UIButton = UIButton (title: " 转发", imageName: "timeline_icon_retweet", selectedHighligtedImage:"timeline_card_middle_background_highlighted", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    
    /// 评论按钮
    private lazy var commentButton: UIButton = UIButton (title: " 评论", imageName: "timeline_icon_comment", selectedHighligtedImage:"timeline_card_middle_background_highlighted", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    
    /// 点赞按钮
    private lazy var praiseButton: UIButton = UIButton (title: " 赞", imageName: "timeline_icon_unlike", selectedHighligtedImage:"timeline_card_middle_background_highlighted", titleColor: UIColor.darkGrayColor(), fontSize: 12)
    
    /// 垂直分隔线1
    private lazy var separateLineViewOne: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    /// 垂直分隔线2
    private lazy var separateLineViewTwo: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    /// 水平分隔线1
    private lazy var lineViewOne: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    /// 水平分隔线2
    private lazy var lineViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
}


