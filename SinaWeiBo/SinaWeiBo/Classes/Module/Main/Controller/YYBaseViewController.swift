//
//  YYBaseViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.

//

import UIKit

class YYBaseViewController: UITableViewController,YYVisitorViewDelegate {
    
    let userLogin = false
    var visitorView: YYVisitorView?
    
    override func loadView() {
        // 判断用户是否登录,如果登录,显示主界面,反之显示访客视图
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    /// 创建访客视图
    func setupVisitorView() {
        
        visitorView = YYVisitorView()
        view = visitorView
        
        // 切换不同控制器页面的访客视图
        if self is YYHomeViewController {
            visitorView?.startRotationAnimation()
        } else if self is YYMessageViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,别人评论你微博,发给你的消息,都会在这里收到通知", isHome: false)
        } else if self is YYDiscoverViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,最新,最热微博尽在掌握,不再会与实事潮流擦肩而过", isHome: false)
        } else if self is YYProfileViewController {
            visitorView?.setupInfo("visitordiscover_image_profile", message: "登录后,你的微博,相册,个人资料会显示在这里,展示给别人", isHome: false)
        }
        // 指定代理
        visitorView?.visitorViewDelegate = self
        
        let barItem = UIBarButtonItem()
        barItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: UIControlState.Normal)
        
        // 添加导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillLogin")
        // 添加导航栏左边按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorViewWillRegister")
        
    }
    
    // MARK: -  实现代理方法
    // 登录
    func visitorViewWillLogin() {
        print(__FUNCTION__)
        
        // 创建授权登录控制器
        let authorizeLoginVC = YYAuthorizeViewController()
        // 跳转到授权登录控制器
        presentViewController(UINavigationController(rootViewController: authorizeLoginVC), animated: true) { () -> Void in
            print("点击了登录按钮,跳转到授权登录界面")
        }
    }
    
    // 注册
    func visitorViewWillRegister() {
        print(__FUNCTION__)
        
    }
    
}


























