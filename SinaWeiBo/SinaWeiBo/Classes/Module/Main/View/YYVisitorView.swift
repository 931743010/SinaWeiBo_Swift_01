//
//  YYVisitorView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.

/// 访客界面

import UIKit

class YYVisitorView: UIView {
    
    
    // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 布局访客视图UI
        self.layoutVisitorUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 设置不同控制器页面显示不同的视图信息
    func setupInfo(imageName: String, message: String, isHome: Bool = true) {
        iconView.image = UIImage(named: imageName)    // 图标
        messageLabel.text = message                   // 信息
        messageLabel.sizeToFit()                      // 自适应size
        houseView.hidden = true                       // 隐藏小房子图标
        sendSubviewToBack(coverView)                  // 将遮盖视图放在父控件最底层
    }
    
    /// 开启旋转动画
    func startRotationAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation") // 核心动画
        animation.duration = 20.0                                       // 持续时间
        animation.toValue = M_PI * 2                                    // 旋转角度
        animation.repeatCount = MAXFLOAT                                // 重复次数
        animation.removedOnCompletion = false                           // 切换界面回来动画不停止
        iconView.layer.addAnimation(animation, forKey: "Rotation")      // 将iconView的图层添加到动画
    }
    
    /// 布局访客视图UI
    func layoutVisitorUI() {
        
        // 添加子控件
        addSubview(iconView)         // 图标转轮
        addSubview(houseView)        // 房子图标
        addSubview(coverView)        // 遮盖视图
        addSubview(messageLabel)     // 信息标签
        addSubview(registerBtn)      // 注册按钮
        addSubview(loginBtn)         // 登录按钮
        
        
        // ---------------使用AutoLayout添加控件约束---------------- //
        // 约束公式: view1.attr1 = view2.attr2 * multiplier + constant
        
        // *******小图标转轮的约束******* //
        // 关闭Autoresizing约束
        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier:1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -50))
        
        // *******小房子的约束******* //
        houseView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        // *******信息标签的约束******* //
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 14))
        self.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 260))
        
        // *******注册按钮的约束******* //
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 14))
        self.addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        self.addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        // *******登录按钮的约束******* //
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 14))
        self.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        self.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height
            , relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        
        // *******遮盖视图的约束******* //
        coverView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: registerBtn, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        /// 设置当前View的背景色
        // self.backgroundColor = UIColor.orangeColor()
        self.backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
        
    }
    
    // MARK: - 懒加载
    // 转轮视图
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "visitordiscover_feed_image_smallicon")
        imageView.image = image
        imageView.sizeToFit()
        return imageView
    }()
    // 房子视图
    private lazy var houseView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "visitordiscover_feed_image_house")
        imageView.image = image
        imageView.sizeToFit()
        return imageView
    }()
    // 遮盖视图
    private lazy var coverView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "visitordiscover_feed_mask_smallicon")
        imageView.image = image
        imageView.sizeToFit()
        return imageView
    }()
    // 信息标签
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "关注一些人,看看有什么趣事分享"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.darkGrayColor()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    // 注册按钮
    private lazy var registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.sizeToFit()
        return button
    }()
    // 登录按钮
    private lazy var loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.sizeToFit()
        return button
    }()
    
}

