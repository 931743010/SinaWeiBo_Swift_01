//
//  YYHomeWebViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/12.
//  Copyright © 2015年 Arvin. All rights reserved.

// 

import UIKit
import SVProgressHUD

class YYHomeWebViewController: UIViewController,UIWebViewDelegate {
    
    // url
    var url: NSURL?
    
    override func loadView() {
        view = webView
        // 指定代理
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏返回按钮
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backClick")
        
        // 发送网络请求
        if let urlString = url {
            let request = NSURLRequest(URL: urlString)
            // 加载网页
            webView.loadRequest(request)
        }
    }
    
    // 返回按钮点击
//    func backClick() {
//        // 返回来源控制器
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    deinit {
        print("网页控制器挂了")
    }
    
    //开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载网页", maskType: SVProgressHUDMaskType.Gradient)
    }
    // 加载网页结束
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // 懒加载webView
    private lazy var webView = UIWebView()
     
}
