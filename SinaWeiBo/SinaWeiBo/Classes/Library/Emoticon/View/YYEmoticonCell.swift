//
//  YYEmoticonCell.swift
//  表情键盘
//
//  Created by Arvin on 15/11/7.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

// MARK: - 自定义表情cell
class YYEmoticonCell: UICollectionViewCell {
    
    // 属性: 表情模型
    var emoticon: YYEmoticon? {
        didSet {
            if let png = emoticon?.pngPath {
                //print("png: \(emoticon?.pngPath)")
                // 设置内容(图片)
                emoticonButton.setImage(UIImage(named: png), forState: UIControlState.Normal)
            } else {
                // 防止cell的图片被重用,设置为nil
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            // 设置emoji表情
            emoticonButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            /*///
            if let emoji = emoticon?.emoji {
            emoticonButton.setTitle(emoji, forState: UIControlState.Normal)
            } else {
            // 防止cell的title被重用,设置为nil
            emoticonButton.setTitle(nil, forState: UIControlState.Normal)
            }
            *///
            // 判断是否是删除按钮模型
            if emoticon!.removeEmoticon {
                // 设置删除按钮表情
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }
        }
    }
    
    // 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("cell of frame: \(frame)")
        prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(emoticonButton)
        // 设置frame
        emoticonButton.frame = CGRectInset(bounds, 6, 6)
        // 禁止按钮的用户交互
        emoticonButton.userInteractionEnabled = false
        // 设置按钮的titleSize
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        // 设置按钮背景色
        //emoticonButton.backgroundColor = UIColor.whiteColor()
    }
    
    // 懒加载表情按钮
    private lazy var emoticonButton = UIButton()
}

