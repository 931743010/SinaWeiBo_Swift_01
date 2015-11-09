//
//  UITextView+Extension.swift
//  表情键盘
//
//  Created by Arvin on 15/11/8.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

extension UITextView {
    /**
    带图片表情的文本
     
     - returns: 返回带图片表情的文本
     */
    func emoticonText() -> String {
        var text = ""
        // 遍历textView.attributedText
        // enumerationRange: 遍历的范围
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length: attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            
            //print("dict: \(dict)")
            //print("range: \(range)")
            //print("------------------")
            
            // 需要获取到表情图片对应的名称
            // 现有类不能满足需求,创建一个类继承NSTextAttachment
            // 如果dict有[NSAttachment]这个key,并且value是[NSTextAttachment],就是表情图片,否则是纯文本
            if let attachment = dict["NSAttachment"] as? YYTextAttachment {
                // 拼接图片表情文本
                text += attachment.name!
            } else {
                // 截取普通文本
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                // 拼接
                text += str
            }
        }
        return text
    }
    
    /**
    添加表情到textView
    
    - parameter emotion: 要添加的表情
    */
    func insertEmoticon(emotion: YYEmoticon) {
        
        // 判断如果是删除按钮
        if emotion.removeEmoticon {
            // 删除文字或表情
            deleteBackward()
        }
        
        // 添加emoji表情
        if let emoji = emotion.emoji {
            // 将表情插入到textView
            insertText(emoji)
        }
        
        // 添加图片表情
        if let pngPath = emotion.pngPath {
            // 创建文本附件
            let attachment = YYTextAttachment()
            
            // 为附件赋值表情的图片的名称
            attachment.name = emotion.chs
            
            // 获得文本内容的线高
            let height = font?.lineHeight ?? 20
            
            // 设置附件的大小
            attachment.bounds = CGRect(x: 0, y: -(height * 0.2), width: height, height: height)
            
            // 将image 添加到附件
            attachment.image = UIImage(contentsOfFile: pngPath)
            
            // 将附件添加到属性文本
            let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            // 给属性文本添加font属性(没有font属性图片后面的表情会很小)
            attrString.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: 0, length: 1))
            
            // 记录选中范围
            let oldSelectedRange = selectedRange
            
            // 获取已有的文本内容,将表情添加到已有文本的里面
            let oldAttrString = NSMutableAttributedString(attributedString: attributedText)
            
            // range: 替换选中的范围
            oldAttrString.replaceCharactersInRange(oldSelectedRange, withAttributedString: attrString)
            
            // 赋值给textView的attributedText
            attributedText = oldAttrString
            
            // 设置光标的位置,在表情的后面
            selectedRange = NSRange(location: oldSelectedRange.location  + 1, length: 0)
            
            // 因为重新设置textView的attributedText没有触发[textViewDidChange]
            // 需要主动调用代理来监听textView的[textViewDidChange]
            delegate?.textViewDidChange?(self)
            // 需要主动发送 UITextViewTextDidChangeNotification 通知
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
        }
    }

}
