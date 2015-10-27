//
//  YYBaseViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.

//

import UIKit

class YYBaseViewController: UITableViewController {
    
    
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
        
        if self is YYHomeViewController {
            visitorView?.startRotationAnimation()
        } else if self is YYMessageViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,别人评论你微博,发给你的消息,都会在这里收到通知", isHome: false)
        } else if self is YYDiscoverViewController {
            visitorView?.setupInfo("visitordiscover_image_message", message: "登录后,最新,最热微博尽在掌握,不再会与实事潮流擦肩而过", isHome: false)
        } else if self is YYProfileViewController {
            visitorView?.setupInfo("visitordiscover_image_profile", message: "登录后,你的微博,相册,个人资料会显示在这里,展示给别人", isHome: false)
        }
        
    }
}
