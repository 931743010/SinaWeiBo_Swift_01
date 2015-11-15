//
//  YYPhotoBrowserViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/14.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYPhotoBrowserViewController: UIViewController {
    
    // MARK: - 属性
    private let photoBrowserViewCellIdentifier = "photoBrowserViewCellIdentifier"
    
    // 大图url地址
    private var urls: [NSURL]
    // 选中的index
    private var selectedIndex: Int
    
    // 便利构造函数
    init(urls: [NSURL], selectedIndex: Int) {
        self.urls = urls
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CollectionView流水布局
    private var layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(colseButton)
        view.addSubview(saveButton)
        view.addSubview(pageLabel)
        
        //collectionView.backgroundColor = UIColor.whiteColor()
        
        // colseButton/saveButton addTarget
        colseButton.addTarget(self, action: "colseButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "saveButtonClick", forControlEvents: UIControlEvents.TouchUpInside)

        let views = [
            "cv": collectionView,
            "cb": colseButton,
            "sb": saveButton,
            "pl": pageLabel]
        
        // clear Autoresizing
        // add collectionView Constraint
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // add pageLabel Constraint
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[pl]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        // add colseButton/saveButton Constraint
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        colseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(30)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(30)]-10-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[cb(75)]-(>=0)-[sb(75)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 设置collectionViewCell
        prepareCollectionViewCell()
    }
    
    //  准备collectionViewCell
    func prepareCollectionViewCell() {
    
        // 注册 collectionViewCell
        collectionView.registerClass(YYPhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserViewCellIdentifier)
        // 设置itemSize
        layout.itemSize = view.bounds.size
        // 设置滚动方向,默认垂直滚动
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置间距
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 分页显示
        collectionView.pagingEnabled = true
        // 取消弹簧效果
        collectionView.bounces = false
        // 设置数据源和代理
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
    // observe colseButton
    func colseButtonClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // observe saveButton
    func saveButtonClick() {
        print("urls: \(urls), index: \(selectedIndex)")
    }
    
    // MARK: - 懒加载
    /// collectionView
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// colseButton
    private lazy var colseButton: UIButton = UIButton(title: "关闭", backgroundImageName: "timeline_card_middle_background_highlighted", titleColor: UIColor.whiteColor(), fontSize: 15)
    
    /// saveButton
    private lazy var saveButton: UIButton = UIButton(title: "保存", backgroundImageName: "timeline_card_middle_background_highlighted", titleColor: UIColor.whiteColor(), fontSize: 15)
    
    /// pageLabel
    private lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.selectedIndex + 1)/\(self.urls.count)"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(16)
        //label.backgroundColor = UIColor.redColor()
        return label
    }()//(fontSize: 10, textColor: UIColor.whiteColor())
    
}

// MARK: - 扩展 实现collectionView的数据源和代理方法
extension YYPhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 返回图片的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 创建自定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserViewCellIdentifier, forIndexPath: indexPath) as! YYPhotoBrowserCell
        // 设置cell要显示的图片的url
        cell.url = urls[indexPath.item]
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    // 监听scrollView的停止滚动,获取当前cell的indexPath
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取当前显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        // 赋值给selectedIndex
        selectedIndex = indexPath.item
        // 设置显示页数
        pageLabel.text = "\(selectedIndex+1)/\(urls.count)"
    }
}
