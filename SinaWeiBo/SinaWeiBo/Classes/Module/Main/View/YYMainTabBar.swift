//
//  YYMainTabBar.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.

/// 自定义tabBar

import UIKit

class YYMainTabBar: UITabBar {
    
    // 定义tabBar的按钮个数
    let count: CGFloat = 5
    
    // 重写layoutSubViews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算每个tabBarItem的宽度
        let width = bounds.width / count
        
        // 设置每个tabBarItem的frame
        let frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        
        var index = 0
        // 遍历子控件
        for view in subviews {
            
            // 判断view是否是某个类型
            if view is UIControl && !(view is UIButton) {
            
                // 设置子控件的偏移位置
                view.frame = CGRectOffset(frame, width * CGFloat(index), 0)
                
                // 三元表达式
                index += index == 1 ? 2 : 1
            }
        }
        // 设置composeButton的frame(添加撰写按钮到中间位置)
        composeButton.frame = CGRectOffset(frame, width * 2, 0)
    }
    
    // MARK: - 懒加载
    lazy var composeButton: UIButton = {
        // 创建按钮
        let button = UIButton()
        
        // 设置按钮图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置按钮背景图片
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 添加按钮到父控件(tabBar)
        self.addSubview(button)
        
        // 返回按钮
        return button
    }()
    
}
