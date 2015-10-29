//
//  YYNetworkTools.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/28.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit
import AFNetworking

class YYNetworkTools: NSObject {
    
    /// 使用 typealias 定义闭包别名
    typealias NetworkFinishedCallback = (result: [String : AnyObject]?, error: NSError?) -> ()
    
    /// 将 AFHTTPSessionManager 定义为属性
    private var afnManager: AFHTTPSessionManager
    
    /// 网络隔离框架单例
    static let sharedInstance: YYNetworkTools = YYNetworkTools()
    
    /// 重写 init()
    override init() {
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        afnManager = AFHTTPSessionManager(baseURL: baseUrl)
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    }
    
    /// 申请应用时分配的AppKey
    private let client_id = "3457660693"
    
    /// 授权回调地址
    let redirect_uri = "http://www.baidu.com/"
    
    /// 请求的类型，填写authorization_code
    private let grant_type = "authorization_code"
    
    /// 申请应用时分配的AppSecret
    private let client_secret = "676bba11e69e66a008d20a6465d8cc68"
    
    /// Oauth授权回调地址
    func oauthURL() -> NSURL {
        // 拼接回调地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        // 强制拆包返回
        return NSURL(string: urlString)!
    }
    
    /// 加载网络请求
    func loadAccessToken(code: String,finished: NetworkFinishedCallback) {
        // oauth2 授权URL
        let urlString = "oauth2/access_token"
        
        // 参数
        let parameters = [
            "client_id" : client_id,
            "client_secret" : client_secret,
            "grant_type" : grant_type,
            "code" : code,
            "redirect_uri" : redirect_uri,
        ]
        
        // 使用AFNetworking发送POST网络请求
        // 给服务器发送的请求数据不能为空,需强制拆包
        POST_Request(urlString, parameters: parameters, finished: finished)
    }
    
    /// 加载用户信息
    func loadUserInfo(finished: NetworkFinishedCallback) {
        // 判断access_token是否为空
        if YYUserAccount.loadAccount()?.access_token == nil {
            return
        }
        // 判断uid是否为空
        if YYUserAccount.loadAccount()?.uid == nil {
            return
        }
        // 用户接口url
        let urlString = "2/users/show.json"
        
        // parameters参数
        let parameters = [
            "uid" : YYUserAccount.loadAccount()!.uid!,
            "access_token" : YYUserAccount.loadAccount()!.access_token!,
        ]
        
        // 使用AFNetworking发送GET网络请求
        // 给服务器发送的请求数据不能为空,需强制拆包
        GET_Request(urlString, parameters: parameters, finished: finished)
    }
    
    /// 封装 AFNetworking 的 GET 请求方法
    func GET_Request(URLString: String, parameters: AnyObject?, finished: NetworkFinishedCallback) {
        afnManager.GET(URLString, parameters: parameters, success: { (_, request) -> Void in
            
            finished(result: request as? [String : AnyObject], error: nil)
            
            }) { (_, error: NSError) -> Void in
                
                finished(result: nil, error: error)
        }
    }
    /// 封装 AFNetworking 的 POST 请求方法
    func POST_Request(URLString: String, parameters: AnyObject?, finished: NetworkFinishedCallback) {
        afnManager.POST(URLString, parameters: parameters, success: { (_, request) -> Void in
            
            finished(result: request as? [String : AnyObject], error: nil)
            
            }) { (_, error: NSError) -> Void in
                
                finished(result: nil, error: error)
        }
    }
    
    // 抽取代码备份
    private func backup_2() {
        /*
        // 网络隔离框架单例
        static let sharedInstance: YYNetworkTools = {
        
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        let tool = YYNetworkTools(baseURL: baseUrl)
        // 往[AFNetworking框架]添加text/plain类型的序列化
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
        
        }()
        
        // 使用AFNetworking发送GET网络请求
        afnManager.GET(urlString, parameters: parameters, success: { (_, request) -> Void in
        // 请求到的用户信息
        print("request: \(request)")
        
        finished(result: request as? [String : AnyObject], error: nil)
        
        }) { (_, error: NSError) -> Void in
        
        print("error: \(error)")
        
        finished(result: nil, error: error)
        }
        
        // 使用AFNetworking发送POST网络请求
        afnManager.POST(urlString, parameters: parameters, success: { (_, request) -> Void in
        
        finished(result: request as? [String : AnyObject], error: nil)
        
        }) { (_, error: NSError) -> Void in
        
        finished(result: nil, error: error)
        }
        */
    }
    
}


