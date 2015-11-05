//
//  YYStatusPictureView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/2.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博配图

import UIKit
import SDWebImage

class YYStatusPictureView: UICollectionView {
    
    /// 配图列数
    let column: Int = 3
    
    /// 配图列间距
    let margin: CGFloat = 6
    
    /// 配图行间距
    let spacing: CGFloat = 4
  
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
        
        // 配图总宽度: (屏幕宽度 - (配图列数 + 1) * 列间距) / 配图列数
        let pictureWidth = (UIScreen.width() - (CGFloat(column) + 1) * margin) / CGFloat(column)
        let itemSize = CGSize(width: pictureWidth, height: pictureWidth)
        layout.itemSize  = itemSize
        
        // 设置最小行间距
        layout.minimumLineSpacing = 0
        // 设置最小列间距
        layout.minimumInteritemSpacing = 0
        
        // 获取微博模型配图数量
        let count = status?.picture_urls?.count ?? 0
        
        // 没有配图
        if count == 0 {
            return CGSizeZero
        }
        // 1 张配图
        if count == 1 {
            // 设置1张图片的默认宽高
            var size = CGSize(width: 150, height: 120)
            
            // 获取到图片的url路径并转换成字符串
            let urlString = status?.picture_urls![0].absoluteString
            
            // 从磁盘中获取到缓存好的图片,有可能没有成功
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
            
            // 如果磁盘中有缓存的图片
            if image != nil {
                // 获取图片的实际尺寸赋值
                size = image.size
            }
            // 重新赋值itemSize
            layout.itemSize = size
            return size
        }
        
        // 重新设置最小行间距
        layout.minimumLineSpacing = spacing
        
        // 4 张配图
        if count == 4 {
            let width = 2 * itemSize.width + spacing
            let size = CGSize(width: width, height: width)
            return size
        }
        // 2,3,5,6,7,8,9 张配图
        // 计算行数 (图片数量 + 列数 - 1) / 列数
        let row = (count + column - 1) / column
        
        // 计算宽度 (列数 * itemSize的宽度) + (列数 - 1) * 间距
        // let width = (CGFloat(column) * itemSize.width) + (CGFloat(column) - 1) * margin
        
        // 计算高度 (行数 * itemSize的宽度) + (行数 - 1) * 间距
        let height = (CGFloat(row) * itemSize.height) + (CGFloat(row) - 1) * margin
        
        return CGSize(width: UIScreen.width() - 2 * 8, height: height)
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
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        // 设置图片填充模式
        image.contentMode = UIViewContentMode.ScaleAspectFill
        // 裁剪填充后多余的图片
        image.clipsToBounds = true
        return image
    }()
    
}


