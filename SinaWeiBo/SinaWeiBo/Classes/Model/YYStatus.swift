//
//  YYStatus.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/31.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博模型数据

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
    
    /// cell的缓存行高
    var rowHeight: CGFloat?
    
    /// 微博作者的用户信息(模型)
    var user: YYUser?
    
    /// 被转发的微博
    var retweeted_status: YYStatus?
    
    /// 微博配图
    /// 当字典转模型给pic_urls赋值的时候,将数组里的url转换成NSURL赋值给storePictureUrls
    var pic_urls: [[String : AnyObject]]? {
        didSet {
            // 判断有没有图片
            let count = pic_urls?.count ?? 0
            // 如果没有图片,直接返回
            if count == 0 {
                return
            }
            // 创建storePictureUrls数组
            storePicture_urls = [NSURL]()
            // 遍历微博配图数组
            for dict in pic_urls! {
                // 转换成url字符串
                if let urlString = dict["thumbnail_pic"] as? String {
                    // 将数组里的url转换成NSURL追加给storePictureUrls
                    storePicture_urls?.append(NSURL(string: urlString)!)
                }
            }
        }
    }
    
    /// 返回微博配图对应的URL数组
    var storePicture_urls: [NSURL]?
    
    /// 计算型属性
    /// 如果是原创微博就返回原创微博的配图,如果是转发微博就返回转发微博的配图
    var picture_urls: [NSURL]? {
        get {
            // 判断是否转发微博
            return retweeted_status == nil ? storePicture_urls : retweeted_status?.storePicture_urls
        }
    }
    
    /// KVC 字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    ///
    /// 当字典里的key在模型里没有对应的属性时,空实现这个方法则不会崩溃
    ///
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    /// 根据retweeted_status判断应该返回的是原创微博还是转发微博的注册cell
    func cellIdentifier() -> String {
        // 如果retweeted_status为空,返回原创微博的注册cell,否则返回转发微博的注册cell
        return retweeted_status == nil ? YYStatusRegisterCell.YYStatusNormalCell.rawValue : YYStatusRegisterCell.YYStatusForwardCell.rawValue
    }
    
    
    //  TODO: -----重要记号-----
    /// KVC 为每个模型属性赋值时都会调用此方法
    ///
    override func setValue(value: AnyObject?, forKey key: String) {
        // 如果赋值的key是"user"时
        if key == "user" {
            // 自已进行字典转模型并赋值
            if let dict = value as? [String : AnyObject] {
                user = YYUser(dict : dict)
                return // 切记要return
            }
        } else if key == "retweeted_status" {
            // 自已进行字典转模型并赋值
            if let dict = value as? [String : AnyObject] {
                retweeted_status = YYStatus(dict: dict)
                return // 切记要return
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
