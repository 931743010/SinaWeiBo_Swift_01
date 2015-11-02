//
//  YYStatusPictureView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/2.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博配图

import UIKit

class YYStatusPictureView: UICollectionView {
    
    /// 配图列数
    let column: Int = 3
    
    /// 配图间距
    let margin: CGFloat = 8
    
    // collectionViewCell 的重用标识
    private let pictureViewIdentifier = "pictureViewIdentifier"
    
    /// 微博模型
    var status: YYStatus? {
        didSet {
            // sizeToFit()
            // 刷新 collectionView
            reloadData()
        }
    }
    
    // sizeToFit()会调用此方法,返回的CGSize系统会设置为当前view的size
    // override func sizeThatFits(size: CGSize) -> CGSize {
    // return calculateViewSize()
    // }
    
    /// 根据微博模型,计算配图尺寸
    func calculateViewSize() -> CGSize {
        
        let pictureWidth = (UIScreen.width() - (CGFloat(column) + 1) * margin) / CGFloat(column)
        let itemSize = CGSize(width: pictureWidth, height: pictureWidth)
        layout.itemSize  = itemSize
        
        // 设置最小行列间距
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 获取微博模型配图数量
        let count = status?.picture_urls?.count ?? 0
        
        // 没有配图
        if count == 0 {
            return CGSizeZero
        }
        // 1 张配图
        if count == 1 {
            let size = CGSize(width: 150, height: 120)
            layout.itemSize = size
            return size
        }
        // 重新设置最小行间距
        layout.minimumLineSpacing = margin
        
        // 4 张配图
        if count == 4 {
            let width = 2 * itemSize.width + margin
            return CGSize(width: width, height: width)
        }
        // 2,3,5,6,7,8,9 张配图
        // 计算行数 (图片数量 + 列数 - 1) / 列数
        let row = (count + column - 1) / column
        
        // 计算宽度 (列数 * itemSize的宽度) + (列数 - 1) * 间距
        let width = (CGFloat(column) * itemSize.width) + (CGFloat(column) - 1) * margin
        
        // 计算高度 (行数 * itemSize的宽度) + (行数 - 1) * 间距
        let height = (CGFloat(row) * itemSize.height) + (CGFloat(row) - 1) * margin
        
        return CGSize(width: width, height: height)
    }
    
    /// 流水布局
    private let layout = UICollectionViewFlowLayout()
    
    /// 构造函数
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        // 设置数据源
        dataSource = self
        // 去除CollectionView的背景色
        backgroundColor = UIColor.clearColor()
        // 注册自定义cell
        registerClass(YYStatusPictureViewCell.self, forCellWithReuseIdentifier: pictureViewIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 扩展 YYStatusPictureView
extension YYStatusPictureView: UICollectionViewDataSource {
    ///
    /// collectionView 数据源方法
    ///
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.picture_urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 获取自定义
        let cell  = dequeueReusableCellWithReuseIdentifier(pictureViewIdentifier, forIndexPath: indexPath) as! YYStatusPictureViewCell
        
        // 从微博模型获取配图赋值给cell
        cell.imageUrl = status?.picture_urls![indexPath.item]
        
        // TODO: -----重要记号-----
        // let url = status?.pic_urls?[indexPath.item]["thumbnail_pic"] as? String
        // cell.imageUrl = NSURL(string: url!)
        
        return cell
    }
}


// MARK: - 自定义cell,显示图片
class YYStatusPictureViewCell: UICollectionViewCell {
    
    /// 属性
    var imageUrl: NSURL? {
        didSet{
            // 从网络加载图片
            iconView.yy_setImageWithURL(imageUrl)
        }
    }
    /// 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 准备UI
    func prepareUI() {
        // 添加到父控件
        contentView.addSubview(iconView)
        // 添加约束,填充子视图
        iconView.ff_Fill(contentView)
    }
    /// 懒加载
    private lazy var iconView: UIImageView = UIImageView()
    
}


