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
        
        // print("启动: \(YYUserAccount.loadAccount())")
        
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
        self.window?.rootViewController = defaultController()
        
        // 设置window的背景颜色
        self.window?.backgroundColor = UIColor.whiteColor()
        
        // 设置主窗口并显示
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    /// 默认显示的控制器
    private func defaultController() -> UIViewController {
        // 判断用户是否登录
        // 每次都需要 == nil
        if !YYUserAccount.userLogin() {
            return YYMainViewController()
        }
        // 判断是否是新版本
        return isNewFeature() ? YYNewFeatureViewController() : YYWelcomeViewController()
    }
    
    /// 判断是否是新版本
    private func isNewFeature() -> Bool {
        
        // 获取当前版本号
        let versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionString)!
        //print("当前版本号: \(currentVersion)")
        
        // 获取之前版本号
        let sandboxVersionKey = "sanboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        //print("之前版本号: \(sandboxVersion)")
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 比较版本号
        return currentVersion > sandboxVersion
    }
    
    /// 切换根控制器
    /// isMain: true: 切换到主界面  false: 切换到欢迎界面
    func switchRootViewController(isMain: Bool) {
        window?.rootViewController = isMain ? YYMainViewController() : YYWelcomeViewController()
    }
    
    /// 设置全局导航栏(皮肤)按钮文字的颜色
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
    
}

