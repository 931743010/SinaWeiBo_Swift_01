//
//  YYStatus.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/31.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYStatus: NSObject {
    
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var idstr: String?
    
    /// 微博来源
    var source: String?
    
    /// 微博信息内容
    var text: String?
    
    /// 微博作者的用户信息(模型)
    var user: YYUser?
    
    /// 微博配图
    var pic_urls: [[String : AnyObject]]?
    
    /// KVC 字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    ///
    /// 当字典里的key在模型里没有对应的属性时,空实现这个方法则不会崩溃
    ///
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    ///
    /// KVC 为每个模型属性赋值时都会调用此方法
    ///
    override func setValue(value: AnyObject?, forKey key: String) {
        // 如果赋值的key是"user"时
        if key == "user" {
            // 自已进行字典转模型并赋值
            if let dict = value as? [String : AnyObject] {
                user = YYUser(dict : dict)
                return
            }
        }
        // return 父类方法
        return super.setValue(value, forKey: key)
    }
    
    ///
    /// 重写description, Print对象
    ///
    override var description: String {
        let keys = ["created_at", "idstr", "source", "text", "user", "pic_urls"]
        return "\n\t微博模型:\(dictionaryWithValuesForKeys(keys))"
    }
    
    
    ///
    /// 加载微博数据
    ///
    class func loadStatus(finishend: (statuses:[YYStatus]?, error: NSError?) -> ()) {
        /// 调用网络工具类加载微博数据
        YYNetworkTools.sharedInstance.loadStatus { (result, error) -> () in
            // 网络加载数据出错
            if error != nil {
                print("error: \(error)")
                // 通知调用者
                finishend(statuses: nil, error: error)
                return
            }
            
            // 判断网络请求结果是否有数据 [[String : AnyObject]]是数组中包含字典
            if let array = result?["statuses"] as? [[String : AnyObject]] {
                // 创建模型数组
                var statuses = [YYStatus]()
                // 遍历
                for dict in array {
                    // 字典转模型
                    statuses.append(YYStatus(dict: dict))
                }
                // 字典转模型完成,通知调用者
                finishend(statuses: statuses, error: nil)
                
            } else {
                // 通知调用者
                finishend(statuses: nil, error: nil)
            }
        }
    }
    
}
