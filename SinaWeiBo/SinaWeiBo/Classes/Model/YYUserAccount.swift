//
//  YYUserAccount.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/29.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYUserAccount: NSObject,NSCoding {
    
    /// 类方法,判断用户是否登录
    /// 判断内存中有没有帐号,有就返回true
    class func userLogin() -> Bool {
        return YYUserAccount.loadAccount() != nil
    }
        
    /// 友好显示名称
    var name: String?
    
    /// 当前授权用户的UID
    var uid: String?
    
    /// 将expires_in 转换成日期
    var expires_date: NSDate?
    
    /// 接口获取授权后的access token
    var access_token: String?
    
    /// 用户头像地址（大图),180×180像素
    var avatar_large: String?
    
    /// 用户帐号(Static),需被多处访问
    private static var userAccount: YYUserAccount?
    
    // 基本数据类型不能定义为可选
    /// access_token的生命周期，单位是秒数
    var expires_in: NSTimeInterval = 0 {
        didSet {
            // 属性监视器
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// KVC 字典转模型
    init(dict: [String : AnyObject]) {
        // 先调用父类
        super.init()
        // 为模型的每个属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 当字典里的key在模型里没有对应的属性时,空实现这个方法则不会崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 重写description, Print对象
    override var description: String {
        return "access_token: \(access_token),expires_in: \(expires_in),uid: \(uid),expires_date: \(expires_date),name: \(name), avatar_large: \(avatar_large)"
    }
    
    // MARK: -加载用户数据
    /// 调用网络工具类加载用户数据
    func loadUserInfo(finished: (error: NSError?) -> ()) {
        // 判断网络请求结果返回的数据
        YYNetworkTools.sharedInstance.loadUserInfo { (result, error) -> () in
            if error != nil || result == nil {
                // 执行闭包(有错误)
                finished(error: error)
                return
            }
            // 加载成功,将请求回来的数据赋值给属性
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 保存数据到沙盒
            self.saveAccount()
            
            // 同步数据到内存,把当前对象赋值给 userAccount
            YYUserAccount.userAccount = self
            // 执行闭包(没错误)
            finished(error: nil)
        }
    }
    
    // 类方法访问属性需要将属性定义为 static
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"
        
    // MARK: - 保存数据
    func saveAccount() {
        // 保存数据到沙盒
        // 对象方法访问需要用 类名.属性名称
        NSKeyedArchiver.archiveRootObject(self, toFile: YYUserAccount.accountPath)
    }
    
    // MARK: - 读取数据
    // 方法名前加上class修饰,就为类方法
    // loadAccount 会频繁调用,并且解档数据比较耗性能,保存到内存中只需要加载一次就好了
    class func loadAccount() -> YYUserAccount? {
        // 判断内存中有没有帐号
        if userAccount == nil {
            // 如果没有才从沙盒解档数据,并赋值给userAccount
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? YYUserAccount
        }
        
        // 如果有帐号,还需判断是否已过期
        // OrderedAscending (<)  OrderedSame (=)  OrderedDescending (>)
        if userAccount != nil && userAccount?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
           // print("内存中有帐号,没有过期")
            return userAccount
        }
        return nil
    }
    
    // MARK: - 归档用户数据
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    // MARK: - 解档用户数据
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
}
