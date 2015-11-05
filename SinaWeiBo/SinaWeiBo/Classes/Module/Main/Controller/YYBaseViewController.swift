//
//  YYBaseViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.

// 访客视图基础类控制器

import UIKit

class YYBaseViewController: UITableViewController {
    
    
    /// 判断用户是否登录
    let userLogin = YYUserAccount.userLogin()
    
    /// 定义访客视图(可选类型)
    var visitorView: YYVisitorView?
    
    // 重写loadView,并给view设置值,将不再会从xib/storyboard加载view
    override func loadView() {
        // 判断用户是否登录,如果登录,显示主界面,反之显示访客视图
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 设置访客视图
    func setupVisitorView() {
        
        visitorView = YYVisitorView()
        view = visitorView
        // print(self)
        
        // 切换不同控制器页面的访客视图
        if self is YYHomeViewController {
            
            // 开启旋转动画
            visitorView?.startRotationAnimation()
            
            // 使用通知监听应用 进入前台 的状态
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
            // 使用通知监听应用 退到后台 的状态
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            
        } else if self is YYMessageViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,别人评论你的微博,发给你的消息,都会在这里收到通知", isHome: false)
            
        } else if self is YYDiscoverViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,最新,最热微博尽在掌握,不再会与实事潮流擦肩而过", isHome: false)
            
        } else if self is YYProfileViewController {
            visitorView?.setupInfo("visitordiscover_image_profile", message: "登录后,你的微博,相册,个人资料会显示在这里,展示给别人", isHome: false)
        }
        // 指定代理
        visitorView?.visitorViewDelegate = self
        
        // 在这里设置全局导航栏按钮颜色迟了,须在AppDelegate中提前设置
        // UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        // 添加导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillLogin")
        // 添加导航栏左边按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillRegister")
        
    }
    
    deinit {
        if self is YYHomeViewController {
            // 移除通知
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    // MARK: - 监听通知
    func didBecomeActive() {
        // 进入前台,恢复旋转动画
        visitorView?.resumeRotationAnimation()
    }
    
    func didEnterBackground() {
        // 退到后台,暂停旋转动画
        visitorView?.pauseRotationAnimation()
    }
    
}

// MARK: - 扩展(Category),实现代理方法
extension YYBaseViewController: YYVisitorViewDelegate {
    /// 登录
    func visitorViewWillLogin() {
        
        // 创建授权登录控制器
        let authorizeLoginVC = YYAuthorizeViewController()
        // 跳转到授权登录控制器
        presentViewController(UINavigationController(rootViewController: authorizeLoginVC), animated: true) { () -> Void in
            print("点击了登录按钮,跳转到授权登录界面")
        }
    }
    
    /// 注册
    func visitorViewWillRegister() {
        print(__FUNCTION__)
    }
}



