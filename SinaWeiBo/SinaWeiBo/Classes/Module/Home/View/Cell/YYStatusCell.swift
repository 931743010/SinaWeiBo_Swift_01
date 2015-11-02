//
//  YYStatusCell.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博自定义Cell

import UIKit

class YYStatusCell: UITableViewCell {
    
    //  MARK: - 属性
    /// 微博配图约束宽度
    var pictureViewWidthCons: NSLayoutConstraint?
    
    /// 微博配图约束高度
    var pictureViewHeightCons: NSLayoutConstraint?
        
    /// 微博模型
    var status: YYStatus? {
        didSet{
            // print("父类属性监视器")
            // 将模型赋值给 topView
            topView.status = status
            // 设置微博内容
            contentLabel.text = status?.text
            // 将微博模型赋值给配图
            pictureView.status = status
            // 获取到配图返回的宽高
            let size = pictureView.calculateViewSize()
            // print("配图size: \(size)")
            // 重新赋值配图的宽高约束
            pictureViewWidthCons?.constant = size.width
            pictureViewHeightCons?.constant = size.height
            
            // TODO: 测试微博配图的高度(随机行:0~3)
            // let row = arc4random_uniform(1000) % 4
            // pictureViewHeightCons?.constant = CGFloat(row) * 90
        }
    }
    
  
    //  MARK: - 返回cell的高度
    /// 设置cell的模型,cell会根据模型,重新设置内容,更新约束,获取子控件的最大Y值
    func rowHeight(status: YYStatus) -> CGFloat {
        // 设置cell的模型
        self.status = status
        // 更新约束
        layoutIfNeeded()
        // 获取子控件的最大Y值
        let maxY = CGRectGetMaxY(bottomView.frame)
        // 返回
        return maxY
    }
    
    
    // MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 准备UI
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    //  MARK: - 准备UI
    ///
    func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 顶部view
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: (UIScreen.width()), height: 53))
        
        // 微博内容
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint.init(x: 8, y: 8))
        
        // 宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        // 底部view
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.width(), height: 44), offset: CGPoint(x: -8, y: 8))
        
        // contentView底部与bottomView底部重合
        //contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
    
    
    //  MARK: - 懒加载
    /// 自定义Cell顶部View
    private lazy var topView: YYStatusTopView = YYStatusTopView()
    
    /// 微博内容
    lazy var contentLabel: UILabel = {
        let label = UILabel(fontSize: 14, textColor: UIColor.blackColor())
        label.numberOfLines = 0
        return label
    }()
    
    /// 自定义微博配图
    lazy var pictureView: YYStatusPictureView = YYStatusPictureView()
    
    /// 自定义Cell底部View
    lazy var bottomView: YYStatusBottomView = YYStatusBottomView()
    
}

