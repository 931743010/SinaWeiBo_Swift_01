//
//  YYStatusCell.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYStatusCell: UITableViewCell {
    
    /// 微博模型
    var status: YYStatus? {
        didSet{
            // 将模型赋值给 topView
            topView.status = status
            // 设置微博内容
            contentLabel.text = status?.text
        }
    }
        
    /// 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
        /// 准备UI
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// 准备UI
    ///
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        
        // 顶部cell
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: (UIScreen.width()), height: 44))
        // 微博内容
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint.init(x: 8, y: 8))

        // 宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        // contentView底部与contentLabel底部重合
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
    
    /// 自定义Cell顶部View
    private lazy var topView: YYStatusTopView = YYStatusTopView()
    
    /// 微博内容
    private lazy var contentLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.blackColor())
        label.numberOfLines = 0
        return label
    }()
    
}
