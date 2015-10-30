//
//  YYWelcomeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/29.
//  Copyright © 2015年 Arvin. All rights reserved.

// 欢迎界面

import UIKit
import SDWebImage

class YYWelcomeViewController: UIViewController {
    
    // 用户头像底部约束
    private var userIconBottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        // 获取用户头像(可选绑定)
        if let iconString = YYUserAccount.loadAccount()?.avatar_large {
            // 网络请求加载头像
            userIconView.sd_setImageWithURL(NSURL(string: iconString), placeholderImage: UIImage(named: "avatar_default_big"))
        }
    }
    
    /// 头像弹跳动画效果
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 开始动画,更改头像的底部约束
        userIconBottomCons?.constant = -(UIScreen.mainScreen().bounds.height - 200)
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.45, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 重新布局View
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                // 嵌套动画
                UIView.animateWithDuration(1, animations: { () -> Void in
                    // 显示标签
                    self.welcomeLabel.alpha = 1
                    }, completion: { (_) -> Void in
                        // 延时1秒执行
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            // 切换控制器,跳转到主界面
                            (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootViewController(true)
                        })
                })
        }
    }
    /// 准备UI
    private func prepareUI() {
        
        // 添加子控件
        view.addSubview(backgroundImageView)
        view.addSubview(userIconView)
        view.addSubview(welcomeLabel)
        
        // ******** VFL 约束背景图片 ******** //
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        
        // ******** 用户头像 ******** //
        userIconView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: userIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: userIconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        view.addConstraint(NSLayoutConstraint(item: userIconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        userIconBottomCons = NSLayoutConstraint(item: userIconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -200)
        view.addConstraint(userIconBottomCons!)
        
        // ******** 欢迎标签 ******** //
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: userIconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: userIconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    }
    
    /// 背景图片
    private lazy var backgroundImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "ad_background"))
    }()
    
    /// 用户头像
    private lazy var userIconView: UIImageView = {
        let userIconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        userIconView.layer.cornerRadius = 42.5
        // userIconView.clipsToBounds = true
        userIconView.layer.masksToBounds = true
        return userIconView
    }()
    
    /// 欢迎回来标签
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        // let userName = YYUserAccount.loadAccount()?.name
        label.text = "Hello! 欢迎回来"
        label.textColor = UIColor.darkGrayColor()
        label.alpha = 0
        label.sizeToFit()
        return label
    }()
    
}
