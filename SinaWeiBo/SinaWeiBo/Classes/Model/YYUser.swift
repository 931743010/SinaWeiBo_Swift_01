//
//  YYUser.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/31.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYUser: NSObject {
    
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 友好显示名称
    var name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 微博认证用户
    /// 没有认证:-1   认证用户:0  企业认证:2,3,5  微博达人:220
    var verified_type: Int = -1
    
    /// 判断认证用户,设置不同的认证图标
    var verified_typeImage: UIImage? {
        switch verified_type {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    /// 会员等级 1 - 6
    var mbrank: Int = 0
    /// (计算型属性)根据会员等级设置不同的等级图片
    var mbrankImage: UIImage? {
        if mbrank > 0 && mbrank <= 6 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        return nil
    }
    
    /// 字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    
    /// 当字典里的key在模型里没有对应的属性时,空实现这个方法则不会崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    /// 重写description, Print对象
    override var description: String {
        let keys = ["idstr", "name", "profile_image_url", "verified_type", "mbrank"]
        return "\n\t用户模型:\(dictionaryWithValuesForKeys(keys))"
    }
}
