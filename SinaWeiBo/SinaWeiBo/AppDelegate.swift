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
        
        print("启动: \(YYUserAccount.loadAccount())")
        
        // 启动界面休眠0.5秒
        NSThread.sleepForTimeInterval(0.5)
        
        // 设置全局导航栏皮肤
        setupAppearance()
        
        // 创建Window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 创建自定义tabBar控制器
        // let tabBar = YYMainViewController()
        
        // 设置窗口根控制器为tabBar
        // ? 前面的变量有值时才执行后面的方法,没值时则啥都不做
        // self.window?.rootViewController = tabBar
        self.window?.rootViewController = YYNewFeatureViewController()
        
        // 设置window的背景颜色
        self.window?.backgroundColor = UIColor.whiteColor()
        
        // 显示主窗口
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupAppearance() {
        // 设置全局导航栏按钮文字的颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
}

