//
//  AppDelegate.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/26.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 启动界面休眠0.5秒
        NSThread.sleepForTimeInterval(0.5)
        
        // 创建Window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 创建自定义tabBar控制器
        let tabBar = YYMainViewController()
        
        // 设置窗口根控制器为tabBar
        self.window?.rootViewController = tabBar
        
        // 设置window的背景颜色
        self.window?.backgroundColor = UIColor.whiteColor()
        
        // 显示主窗口
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

