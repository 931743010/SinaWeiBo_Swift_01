//
//  YYAuthorizeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/27.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit
import SVProgressHUD

class YYAuthorizeViewController: UIViewController {
    
    // 1.添加UIWebview
    override func loadView() {
        view = webView
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        // 设置标题
        self.title = "新浪微博"
        // 添加导航栏右边按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick")
        
        // 2.加载网页
        let request = NSURLRequest(URL: YYNetworkTools.sharedInstance.oauthURL())
        webView.loadRequest(request)
    }
    
    /// 取消按钮
    func cancelBtnClick() {
        // 隐藏加载进度指示器
        SVProgressHUD.dismiss()
        // 返回到访客视图界面控制器
        dismissViewControllerAnimated(true) { () -> Void in
            print("点击了取消按钮,返回到访客视图界面")
        }
    }
    
    // MARK: - 懒加载webView
    private lazy var webView = UIWebView()
}


// MARK: - 扩展(Catgoty) UIWebViewDelegate 代理方法
extension YYAuthorizeViewController: UIWebViewDelegate {
    
    /// 开始加载请求时触发
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示加载进度指示器
        SVProgressHUD.showWithStatus("☺️正在加载", maskType: SVProgressHUDMaskType.Gradient)
    }
    
    /// 请求加载完毕时触发
    func webViewDidFinishLoad(webView: UIWebView) {
        // 隐藏加载进度指示器
        SVProgressHUD.dismiss()
    }
    
    /// 询问是否加载请求(request)
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 回调地址
        // https://api.weibo.com/oauth2/authorize?client_id=3457660693&redirect_uri=http://www.baidu.com/
        // 允许授权
        // http://www.baidu.com/?code=501d683eec21586ce5a8e53f12519ad6
        // 取消授权
        // http://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        
        // 授权回调地址
        let urlString = request.URL!.absoluteString
        print("urlString: \(urlString)")
        
        // 如果加载的不是回调地址
        if !urlString.hasPrefix(YYNetworkTools.sharedInstance.redirect_uri) {
            // 可以加载
            return true
        }
        
        // 如果点击的是授权或取消则拦截不加载回调地址
        if let query = request.URL?.query {
            
            print("query: \(query)")
            
            let codeString = "code="
            
            // 判读是否以"code="开头
            if query.hasPrefix(codeString) { // 允许授权
                
                // 转换成OC字符串
                let nsQuery = query as NSString
                
                // 截取 "code=" 后的字符串
                let code = nsQuery.substringFromIndex(codeString.characters.count)
                
                print("code: \(code)")
                
                // 获取到访问令牌(access token)
                loadAccessToken(code)
                
            } else { // 取消授权
                
            }
        }
        return false
    }
    // MARK: -
    /// 调用网络工具类加载access token
    func loadAccessToken(code: String) {
        
        YYNetworkTools.sharedInstance.loadAccessToken(code) { (result, error) -> () in
            // 如果网络加载返回的结果为空或者错误
            if error != nil || result == nil {
                self.showError("😂网络不给力")
                return
            }
            print("result: \(result)")
            
            let account = YYUserAccount.init(dict: result!)
            
            /// 保存用户帐号到沙盒
            account.saveAccount()
            
            /// 加载用户信息
            account.loadUserInfo({ (error) -> () in
                // 网络请求错误
                if error != nil {
                    self.showError("😰获取用户信息失败")
                    return
                }
                print("account: \(account)")
                // 网络请求成功
                self.cancelBtnClick()
                // 切换根控制器
                (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootViewController(false)
            })
        }
    }
    
    /// 显示错误信息提示
    private func showError(message: String) {
        // 提示错误信息
        SVProgressHUD.showErrorWithStatus(message, maskType: SVProgressHUDMaskType.Gradient)
        // 延时1秒 返回到访客视图界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.cancelBtnClick()
        })
    }
}

