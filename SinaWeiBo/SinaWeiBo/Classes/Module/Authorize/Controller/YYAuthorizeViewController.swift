//
//  YYAuthorizeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYAuthorizeViewController: UIViewController {
    
    override func viewDidLoad() {
        // 设置标题
        self.title = "新浪微博"
        // 添加导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick")
    }
    
    // 取消按钮
    func cancelBtnClick() {
        dismissViewControllerAnimated(true) { () -> Void in
            print("点击了取消按钮,返回到访客视图界面")
        }
    }
    
    deinit {
        print("登录页面挂了")
    }
    
}
