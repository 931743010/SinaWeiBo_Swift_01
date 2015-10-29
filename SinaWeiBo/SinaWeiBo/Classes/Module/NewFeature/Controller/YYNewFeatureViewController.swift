//
//  YYNewFeatureViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/29.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YYNewFeatureViewController: UICollectionViewController {
    
    // MARK: - 属性
    private let itemCount = 4
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()
    
    /// 重写 init()
    init() {
        super.init(collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// viewDidLoad方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册 CollectionView
        self.collectionView!.registerClass(YYNewFeaetureCall.self, forCellWithReuseIdentifier: reuseIdentifier)
        // 设置layout的参数
        prepareLayout()
    }
    
    // MARK: - 设置layout的参数
    private func prepareLayout() {
        // 设置item的大小
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 滚动方向(水平)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置分页
        collectionView?.pagingEnabled = true
        // 取消弹簧效果
        collectionView?.bounces = false
    }
    
    // MARK: - CollectionView的数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 创建cell,强转成自定义的 YYNewFeaetureCall
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YYNewFeaetureCall
        
        cell.imageIndex = indexPath.item
        //cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
    // CollectionView的分页滚动完毕后,cell看不到时会触发
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 正在显示的cell的indexPath
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
        
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! YYNewFeaetureCall
        
        // 判断是否是最后一页
        if showIndexPath.item == itemCount - 1 {
            
            // 开始按钮的动画效果
            cell.startButtonAnimation()
        }
    }
}

// MARK: - 自定义 YYNewFeaetureCall
class YYNewFeaetureCall: UICollectionViewCell {
    
    // MARK: - 属性
    // 用属性监视器,监听属性值的改变
    // 在 cell 即将显示的时候会调用
    var imageIndex: Int = 0 {
        didSet {
            // 设置滚动图片
            backgroundImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            // 隐藏按钮
            startButton.hidden = true
        }
    }
    
    // MARK: - 重写构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 准备 UI
        prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 立即体验按钮动画效果
    private func startButtonAnimation() {
        startButton.hidden = false
        // 设置按钮的 transform 缩放比例: 0,0
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        // UIView 动画
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
        }
    }
    
    /// 准备 UI
    private func prepareUI() {
        // 添加子控件到 contentView
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(startButton)
        
        // VFL 添加约束
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        
        // 添加按钮的约束
        startButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
        
    }
    
    /// 按钮点击事件
    func startButtonClick() {
        print(__FUNCTION__)
    }
    
    // MARK: - 懒加载背景图/体验按钮
    private lazy var backgroundImageView: UIImageView = UIImageView()
    
    /// 立即体验按钮
    private lazy var startButton: UIButton = {
        
        let button = UIButton()
        // 设置按钮背景图(默认/高亮状态)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        // 设置按钮文字
        button.setTitle("立即体验", forState: UIControlState.Normal)
        // 添加按钮的点击事件
        button.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
}
