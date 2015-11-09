//
//  YYNetworkTools.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/28.
//  Copyright © 2015年 Arvin. All rights reserved.

// 网络请求工具类

import UIKit
import AFNetworking

///
// MARK: - 定义网络错误枚举
///
enum YYNetworkError: Int {
    case emptyToken = -1
    case emptyUid = -2
    
    // 枚举中可以定义属性
    var description: String {
        get {
            // 根据枚举的类型返回对应的错误
            switch self {
            case YYNetworkError.emptyToken:
                return "Access Token 为空"
            case YYNetworkError.emptyUid:
                return "Uid 为空"
            }
        }
    }
    // 枚举中可以定义方法
    func error() -> NSError {
        /// 由于错误code分散不好管理,所以自定义error方法
        /// domain:    错误范围(自定义)
        /// code:      错误代码,负数开头(自定义)
        /// userInfo:  发生错误的附加信息
        return NSError(domain: "cn.Arvin.error.network", code: rawValue, userInfo: ["errorDescription" : description])
    }
}

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
    
    ///
    // MARK: - Oauth授权回调地址
    ///
    func oauthURL() -> NSURL {
        // 拼接回调地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        // 强制拆包返回
        return NSURL(string: urlString)!
    }
    
    
    ///
    // MARK: - 加载请求 AccessToken
    ///
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
    
    
    ///
    // MARK: - 加载用户信息
    ///
    func loadUserInfo(finished: NetworkFinishedCallback) {
        
        ///
        /// 判断access_token是否为空
        ///
        
        /* 可选绑定,有值才进来
        if let parameters = tokenDict() {
            // 变量 parameters 只能在此代码块中能使用
            print("parameters:\(parameters) 有值..")
        }
        
        // 判断access_token是否为空
        if tokenDict() == nil {
        // 获取枚举对应的值,调用自定义的错误方法
        let error = YYNetworkError.emptyToken.error()
        // 提示调用者错误信息
        finished(result: nil, error: error)
        return
        }*/
        
        // 守卫,与可选绑定相反,没值才进来
        // 变量 parameters 能在定义后的所有代码块中使用
        guard var parameters = tokenDict() else {
            
            // 获取枚举对应的值,调用自定义的错误方法
            let error = YYNetworkError.emptyToken.error()
            // 提示调用者错误信息
            finished(result: nil, error: error)
            return
        }
        
        ///
        /// 判断uid是否为空
        ///
        if YYUserAccount.loadAccount()?.uid == nil {
            // 获取枚举对应的值,调用自定义的错误方法
            let error = YYNetworkError.emptyUid.error()
            // 提示调用者错误信息
            finished(result: nil, error: error)
            return
        }
        
        // 用户接口url
        let urlString = "2/users/show.json"
        // parameters参数
        parameters["uid"] = YYUserAccount.loadAccount()?.uid!
        
        /*
        let parameters = [
            "uid" : YYUserAccount.loadAccount()!.uid!,
            "access_token" : YYUserAccount.loadAccount()!.access_token!,
        ]*/
        
        // 使用AFNetworking发送GET网络请求
        // 给服务器发送的请求数据不能为空,需强制拆包
        GET_Request(urlString, parameters: parameters, finished: finished)
    }
    
    ///
    /// 判断Access Token是否有值,有值返回字典;没值则返回nil
    ///
    private func tokenDict() -> [String : AnyObject]? {
        if YYUserAccount.loadAccount()?.access_token == nil {
            return nil
        }
        return ["access_token" : YYUserAccount.loadAccount()!.access_token!]
    }
    
    /**
    - parameter since_id: 若指定此参数,则返回ID比since_id大的微博(即比since_id时间晚的微博),默认为0
    - parameter max_id:   若指定此参数,则返回ID小于或等于max_id的微博,默认为0
    - parameter finished: 闭包回调
    */
    // MARK: - 加载微博数据
    func loadStatus(since_id: Int, max_id: Int, finished: NetworkFinishedCallback) {
        /*
        if let accessToken = YYUserAccount.loadAccount()?.access_token {
            // print("\(accessToken)有值")
            // 微博数据接口
            let urlString = "2/statuses/home_timeline.json"
            
            // 接口参数:access_token
            let parameters = ["access_token" : accessToken]
            
            // 使用AFNetworking发送GET网络请求
            GET_Request(urlString, parameters: parameters, finished: finished)
        }*/
        
        // 守卫,与可选绑定相反,没值才进来
        guard var parameters = tokenDict() else {
            // access_token 没有值
            finished(result: nil, error: YYNetworkError.emptyToken.error())
            return
        }
        
        // TODO:-------记号-------
        // 添加参数since_id和max_id
        // 先判断是否有传入这两个参数
        if since_id > 0 {
            parameters["since_id"] = since_id
        } else if max_id > 0 {
            parameters["max_id"] = max_id - 1
        }
        
        // 微博数据接口
        // access_token 有值
        let urlString = "2/statuses/home_timeline.json"
        
        // 网络不给力,加载本地服务器数据
        // loadLocalStatus(finished)

        // 使用AFNetworking发送GET网络请求,加载网络数据
        GET_Request(urlString, parameters: parameters, finished: finished)
    }
    
    
    ///
    //  MARK: - 发布微博
    /**
    发布微博
    
    - parameter status:   微博文本内容
    - parameter finished: 闭包回调
    */
    func sendStatus(status: String, finished:NetworkFinishedCallback) {
        // 守卫,与可选绑定相反,没值才进来
        guard var parameters = tokenDict() else {
            // access_token 没有值
            finished(result: nil, error: YYNetworkError.emptyToken.error())
            return
        }
        
        // 参数,要发布的微博文本内容,必须做URLencode,内容不超过140个汉字
        parameters["status"] = status
        
        // 请求路径
        let urlString = "2/statuses/update.json"
        
        // 使用AFNetworking发送POST网络请求
        POST_Request(urlString, parameters: parameters, finished: finished)
        
    }
    
    
    ///
    //  MARK: - 本地测试数据
    /// 加载本地服务器微博数据
    private func loadLocalStatus(finished: NetworkFinishedCallback) {
        // 获取本地文件路径
        let path = NSBundle.mainBundle().pathForResource("statuses", ofType: "json")
        // 加载文件
        let data = NSData(contentsOfFile: path!)
        
        do {
            // 转换成json 数据
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            // 获取到数据
            finished(result: json as? [String : AnyObject], error: nil)
            
        } catch {
            print("加载数据出错!")
        }
    }
    
    
    ///
    // MARK: - 封装 AFNetworking 的 GET 请求方法
    ///
    func GET_Request(URLString: String, parameters: AnyObject?, finished: NetworkFinishedCallback) {
        afnManager.GET(URLString, parameters: parameters, success: { (_, request) -> Void in
            
            finished(result: request as? [String : AnyObject], error: nil)
            
            }) { (_, error: NSError) -> Void in
                
                finished(result: nil, error: error)
        }
    }
    
    ///
    // MARK: - 封装 AFNetworking 的 POST 请求方法
    ///
    func POST_Request(URLString: String, parameters: AnyObject?, finished: NetworkFinishedCallback) {
        afnManager.POST(URLString, parameters: parameters, success: { (_, request) -> Void in
            
            finished(result: request as? [String : AnyObject], error: nil)
            
            }) { (_, error: NSError) -> Void in
                
                finished(result: nil, error: error)
        }
    }
    
    ///
    /// 抽取代码备份
    ///
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


