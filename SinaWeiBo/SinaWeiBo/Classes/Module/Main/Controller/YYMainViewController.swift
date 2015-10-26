//
//  YYMainViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/26.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYMainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置tabBar的图标颜色
        tabBar.tintColor = UIColor.orangeColor()
        
        // 添加[首页]控制器
        let homeVC = YYHomeViewController()
        self.addChildViewController(homeVC, title: "首页", nmlImgName: "tabbar_home")
        
        // 添加[消息]控制器
        let messageVC = YYMessageViewController()
        self.addChildViewController(messageVC, title: "消息", nmlImgName: "tabbar_message_center")
        
        // 添加[发现]控制器
        let discoverVC = YYDiscoverViewController()
        self.addChildViewController(discoverVC, title: "发现", nmlImgName: "tabbar_discover")
        
        // 添加[我]控制器
        let profileVC = YYProfileViewController()
        self.addChildViewController(profileVC, title: "我", nmlImgName: "tabbar_profile")
        
    }
    
    /**
    添加tabBar的导航控制器的子控制器
    
    - parameter Controller:      子控制器
    - parameter title:           子控制器标题
    - parameter nmlImgName:      子控制器图标
    */
    private func addChildViewController(controller: UIViewController, title: String, nmlImgName: String) {
        // 设置标题
        controller.title = title
        // 设置图标
        controller.tabBarItem.image = UIImage(named: nmlImgName)
        // 添加导航控制器的子控制器
        self.addChildViewController(UINavigationController(rootViewController: controller))
    }
    
    
    // 备份
    private func backup() {
//        homeVC.title = "首页"
//        homeVC.tabBarItem.image = UIImage(named: "tabbar_home")
//  // 设置选中图片的颜色                                                                              homeVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: UIControlState.Selected)
// 设置选中图片的渲染模式
//  homeVC.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")?.imageWithRenderingMode( UIImageRenderingMode.AlwaysOriginal)
//        // 添加tabBar控制器的子控制器
//        addChildViewController(UINavigationController(rootViewController: homeVC))


//        messageVC.title = "消息"
//        messageVC.tabBarItem.image = UIImage(named: "tabbar_message_center")
//        // 添加tabBar控制器的子控制器
//        addChildViewController(UINavigationController(rootViewController: messageVC))


//        discoverVC.title = "发现"
//        discoverVC.tabBarItem.image = UIImage(named: "tabbar_discover")
//        // 添加tabBar控制器的子控制器
//        addChildViewController(UINavigationController(rootViewController: discoverVC))


//        profileVC.title = "我"
//        profileVC.tabBarItem.image = UIImage(named: "tabbar_profile")
//        // 添加tabBar控制器的子控制器
//        addChildViewController(UINavigationController(rootViewController: profileVC))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
