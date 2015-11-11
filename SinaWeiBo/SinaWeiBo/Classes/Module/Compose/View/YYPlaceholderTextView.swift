//
//  YYPlaceholderTextView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/7.
//  Copyright © 2015年 Arvin. All rights reserved.

// 自定义textView

import UIKit

class YYPlaceholderTextView: UITextView {
    
    // MARK: - 属性
    /// 占位文本
    var placeholderText: String? {
        didSet {
            // 占位文本标签的内容,由外界传入
            placeholderLabel.text = placeholderText
            // 占位文本的字体大小等于UITextView的字体大小
            placeholderLabel.font = font
            placeholderLabel.sizeToFit()
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        prepareUI()
        
        // 设置代理,控制器设置textView的代理会把这个代理覆盖,因为代理是1对1的
        // delegate = self
        
        // 使用通知监听textView文本输入框的改变
        // object: 通知的发送者
        // nil: 表示任何人发送的通知都可以监听
        // self: 只有自己发送的通知才能监听到,这里只需要自己监听就好了
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: self)
    }
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 监听textView文本输入框的改变
    func textDidChange() {
        // hasText() 判断文本是否为空
        // 当textView输入内容的时候占位文本消失
        placeholderLabel.hidden = hasText()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        
        // 添加子控件
        addSubview(placeholderLabel)
        // 添加约束
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    // MARK: - 懒加载
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
}

// MARK: - 扩展,实现 UITextViewDelegate 代理方法
//extension YYPlaceholderTextView: UITextViewDelegate {
//    
//    // 监听textView文本框的改变
//    func textViewDidChange(textView: UITextView) {
//        // 当textView输入内容的时候占位文本消失
//        placeholderLabel.hidden = hasText()
//    }
//}


