//
//  YYEmoticon.swift
//  表情键盘
//
//  Created by Arvin on 15/11/7.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

// MARK: - 表情包模型
class YYEmoticonPackage: NSObject {
    
    // 获取表情包文件的bundle路径
    private static let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")!
    
    /// 表情包文件夹
    var id: String?
    
    /// 表情包名称
    var group_name_cn: String?
    
    /// 表情模型数组
    var emoticons: [YYEmoticon]?
    
    /// 构造方法,表情包
    init(id: String) {
        self.id = id
        super.init()
    }
    
    /// 打印对象
    override var description: String {
        return "\n\t表情包模型:id: \(id),group_name_cn: \(group_name_cn),emoticons: \(emoticons)"
    }
    
    /// 每次进入发微博界面弹出自定义的表情键盘都会加载所有的表情包,这样比较耗性能
    /// 需要做到只加载一次就够,然后将其保存到内存中,以后直接访问内存中的表情包数据
    static let packages: [YYEmoticonPackage] = YYEmoticonPackage.loadPackages()
    
    /// 加载所有表情包
    private class func loadPackages() -> [YYEmoticonPackage] {
        print("加载所有的表情包")
        /// 表情包数组
        var packages = [YYEmoticonPackage]()
        
        // 获取(拼接)表情包文件中的plist文件路径
        let plistPath = bundlePath + "/emoticons.plist"
        
        // 加载plist
        let plistDict = NSDictionary(contentsOfFile: plistPath)!
        //print("plistDict: \(plistDict)")
        
        // 创建"最近"表情包
        let recent = YYEmoticonPackage(id: "")
        
        // 设置表情包名称
        recent.group_name_cn = "最近"
        
        // 添加到表情包数组
        packages.append(recent)
        
        // 初始化"最近"表情包
        recent.emoticons = [YYEmoticon]()
        
        // 添加空包和删除按钮
        recent.appendEmptyEmoticon()
        
        // 获取packages数组中每个字典的key为id的值
        if let packageArray = plistDict["packages"] as? [[String : AnyObject]] {
            
            // 遍历数组中的字典
            for dict in packageArray {
                
                // 获取字典中key为"id"的值
                let id = dict["id"] as! String
                
                // 创建表情包,表情包中只有"id",其它数据需要知道表情包的文件名称才能解析
                let package = YYEmoticonPackage.init(id: id)
                
                // 让表情包进一步加载其它数据(表情模型,表情包名称)
                package.loadEmoticon()
                
                // 将表情包添加到表情包数组
                packages.append(package)
            }
        }
        // 返回表情包数组
        return packages
    }
    
    /// 加载表情包中的所有表情和其它数据
    func loadEmoticon() {
        
        // 获取表情包文件夹里面的info.plist文件
        let infoPath = YYEmoticonPackage.bundlePath + "/" + id! + "/info.plist"
        
        // 加载info.plist路径
        let infoDict = NSDictionary(contentsOfFile: infoPath)!
        //print("infoDict: \(infoDict)")
        
        // 获取表情包名称赋值
        group_name_cn = infoDict["group_name_cn"] as? String
        
        // 创建表情模型数组(初始化)
        emoticons = [YYEmoticon]()
        
        // 记录当前按钮
        var index = 0
        // 获取表情模型
        if let array = infoDict["emoticons"] as? [[String : String]] {
            // 遍历表情模型数组
            for dict in array {
                // 字典转模型,创建表情模型
                emoticons?.append(YYEmoticon(id: id,dict: dict))
                
                index++
                // 如果当前按钮 == 20
                if index == 20 {
                    // 创建删除按钮添加到模型数组的最后一个位置
                    emoticons?.append(YYEmoticon(removeEmoticon: true))
                    // 重置index
                    index = 0
                }
            }
        }
        // 添加空白和删除按钮表情
        appendEmptyEmoticon()
    }
    
    /// 添加空白和删除按钮表情
    func appendEmptyEmoticon() {
        
        // 判断最后一页是否满21个表情
        let count = emoticons!.count % 21
        // 不够21个,有count个表情
        // 如果是"最近"表情包, emoticons!.count == 0
        if count > 0 || emoticons!.count == 0 {
            // 追加的数量? 使用范围运算遍历
            // count == 1  追加20 - 1 = 19  (1..<20)加上删除按钮
            // count == 2  追加20 - 2 = 18  (2..<20)加上删除按钮
            // ......
            for _ in count..<20 {
                // 创建空白按钮追加到表情模型数组
                emoticons?.append(YYEmoticon(removeEmoticon: false))
            }
            // 最后一个添加删除按钮表情
            emoticons?.append(YYEmoticon(removeEmoticon: true))
        }
    }
    
    /**
     添加表情到"最近"表情包模型中
     
     - parameter emoticon: 要添加的表情
     */
    class func addFavorite(emoticon: YYEmoticon) {
        // 如果是删除按钮表情,直接返回,啥都不做 
        if emoticon.removeEmoticon {
            return
        }        
        // 让表情的使用次数增加
        emoticon.times++
        
        // 找到最近表情包中的所有表情模型
        var recentEmoticons = packages[0].emoticons
        
        // 不管添加多少个表情,最多只能有20个表情+1个删除按钮
        let removeEmoticon = recentEmoticons!.removeLast()
        
        // 如果最近表情包已经有同样的表情,就不需要重再复添加
        let contains = recentEmoticons!.contains(emoticon)
        // 表情包没有这个表情
        if !contains {
            // 添加到"最近"表情包
            recentEmoticons?.append(emoticon)
        }
        
        // 根据使用次数排序,使用多的表情排在前面
        recentEmoticons = recentEmoticons?.sort({ (e1, e2) -> Bool in
            // 根据times降序排序,times大的排在前面
            return e1.times > e2.times
        })
        
        // 如果前面有添加,就删除最后一个,没有则不删除
        if !contains {
            recentEmoticons?.removeLast()
        }
        
        // 将删除按钮重新添加回来
        recentEmoticons?.append(removeEmoticon)
        
        // 重新赋值回去
        packages[0].emoticons = recentEmoticons
        
//        print("recentEmoticons:\(recentEmoticons)")
//        print("recentEmoticons:\(recentEmoticons?.count)")
//        print("packages[0].emoticons:\(packages[0].emoticons)")
//        print("packages[0].emoticons:\(packages[0].emoticons?.count)")
    }
    
}


// MARK: - 表情模型
class YYEmoticon: NSObject {
    
    /// 记录表情的点击次数
    var times = 0
    
    /// 表情文件夹名称
    var id: String?
    
    /// 表情名称,用于网络传输
    var chs: String?
    
    /// 表情图片对应的名称
    /// 根据这个名称无法找到对应的表情
    var png: String? {
        didSet {
            // 需要拼接表情图片的完整路径
            pngPath = YYEmoticonPackage.bundlePath + "/" + id! + "/" + png!
        }
    }
    
    /// 表情图片的路径
    var pngPath: String?
    
    /// emoji表情对应的十六进制字符串
    var code: String? {
        didSet {
            guard let code = code else {
                // code妹纸,直接返回
                return
            }
            // 有值,将code转换成emoji表情
            // 创建扫描器
            let canner = NSScanner(string: code)
            // 存储扫描结果
            // result:可变的UInt32类型的指针
            var result: UInt32 = 0
            canner.scanHexInt(&result)
            let char = Character(UnicodeScalar(result))
            emoji = String(char)
        }
    }
    
    /// emoji表情
    var emoji: String?
    
    /// 删除按钮表情模型
    /// true: 表示删除按钮表情
    /// false: 表示空白,啥都没有
    var removeEmoticon: Bool = false
    
    /// 通过这个构造方法创建出来的表情,要么是删除按钮,要么是空白
    init(removeEmoticon: Bool) {
        self.removeEmoticon = removeEmoticon
        super.init()
    }
    
    /// 字典转模型,创建的不是图片表情模型就是emoji表情模型
    init(id: String?, dict:[String : AnyObject]) {
        self.id = id
        super.init()
        // 使用KVC赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 当字典中的key在模型中没有对应的属时,程序不会崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印对象
    override var description: String {
        return "\n\n\t表情模型:chs: \(chs),png: \(png),code: \(code) removeEmoticon: \(removeEmoticon), times:\(times)"
    }
    
    
    /// 将表情模型转换成带表情图片的属性文本字符串
    func emoticonToAttrString(font: UIFont) -> NSAttributedString {
        // 守卫
        guard let pngPath = pngPath else {
            // 没有图片
            return NSAttributedString(string: "")
        }
        
        // 创建文本附件
        let attachment = YYTextAttachment()
        
        // 为附件赋值表情的图片的名称
        attachment.name = chs
        
        // 获得文本内容的线高
        let height = font.lineHeight ?? 20
        
        // 设置附件的大小
        attachment.bounds = CGRect(x: 0, y: -(height * 0.2), width: height, height: height)
        
        // 将image 添加到附件
        attachment.image = UIImage(contentsOfFile: pngPath)
        
        // 将附件添加到属性文本
        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        // 给属性文本添加font属性(没有font属性图片后面的表情会很小)
        attrString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        
        return attrString
    }
    
    /// 根据表情文本获取对应的表情模型
    class func emoticonStringToEmoticon(emoticonString: String) -> YYEmoticon? {
        // 接收遍历的结果
        var emoticon: YYEmoticon?
        
        // 遍历所有表情模型,判断表情模型的名称是否等于 emoticonString
        for package in YYEmoticonPackage.packages {
            
            // 获取对应的表情包,过滤
            let result = package.emoticons?.filter({ (e1) -> Bool in
                // 返回结果
                return e1.chs == emoticonString
            })
            // 获取到遍历匹配的第一个结果
            emoticon = result?.first
            // 如果有结果则不再遍历
            if emoticon != nil {
                break
            }
        }
        return emoticon
    }
    
    
    /**
     将表情文本转换成表情图片属性文本
     - parameter string: 表情文本
     - returns: 表情图片属性文本
     */
    class func emoticonStringToEmoticonAttrString(string: String, font: UIFont) -> NSAttributedString {
        
        // 匹配规则
        let pattern = "\\[.*?\\]"
        // 使用正则表达式匹配字符串
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        // 查找string中的表情字符串
        let result = regular.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.characters.count))
        
        /*遍历
        for result in result {
        // 获取到表情字符串的范围
        let range = result.rangeAtIndex(0)
        print("range: \(range)")
        }*/
        
        // 创建可变属性文本字符串
        let attrString_M = NSMutableAttributedString(string: string)
        
        // 反过来截取字符串
        var count = result.count
        while count > 0 {
            let res = result[--count]
            //print("res:\(res.numberOfRanges)")
            // 获取到表情字符串的范围
            let range = res.rangeAtIndex(0)
            
            // 截取范围内的表情文本
            let emoticonSting = (string as NSString).substringWithRange(range)
            //print("表情字符串: \(emoticonSting)")
            
            // 根据表情文本获取对应的表情模型
            if let emoticonStr = YYEmoticon.emoticonStringToEmoticon(emoticonSting) {
                //print("找到表情: \(emoticonStr)")
                
                // 将表情模型转换成带表情图片的属性文本字符串
                let attrString = emoticonStr.emoticonToAttrString(font)
                // 将范围内的表情文本替换成表情图片属性文本
                attrString_M.replaceCharactersInRange(range, withAttributedString: attrString)
            }
        }
        return attrString_M
    } 
}
