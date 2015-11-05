//
//  YYComposeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/5.
//  Copyright © 2015年 Arvin. All rights reserved.

// 发送微博控制器

import UIKit

class YYComposeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // 背景色
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    /// 准备UI
    private func prepareUI() {
        setupNavigationBar()
    }
    
    /// 设置导航栏按钮
    func setupNavigationBar() {
        // 左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtn")
        // 右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        // 设置按钮不可用
        navigationItem.rightBarButtonItem?.enabled = false
        // 设置导航栏标题
        setupTitleView()
    }
    
    
    /// 设置导航栏标题
    private func setupTitleView() {
        let prefix = "撰写微博"
        if let name = YYUserAccount.loadAccount()?.name {
            let titleName = prefix + "\n" + name
            
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(16)
            label.textAlignment = NSTextAlignment.Center
            // 可变字符串
            let attString = NSMutableAttributedString(string: titleName)
            // 转换成OC字符串获取name的范围
            let nameRange = (titleName as NSString).rangeOfString(name)
            // 设置范围内的字体大小/颜色
            attString.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14),NSForegroundColorAttributeName:UIColor.darkGrayColor()], range: nameRange)
            // 将可变字符串赋值给属性文本
            label.attributedText = attString
            label.sizeToFit()
            navigationItem.titleView = label
            
        } else {
            navigationItem.title = prefix
        }
    }
    
    /// 取消按钮
    @objc private func cancelBtn() {
        // 返回来源控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 发送微博按钮
    func sendStatus() {
        print(__FUNCTION__)
    }
    
}
