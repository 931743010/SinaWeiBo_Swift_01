//
//  YYEmoticonViewController.swift
//  表情键盘
//
//  Created by Arvin on 15/11/7.
//  Copyright © 2015年 Arvin. All rights reserved.
//
/*
   使用控制器的view作为textView的自定义键盘,控制器view的大小只有在viewDidAppear方法里才能确定
*/
import UIKit

class YYEmoticonViewController: UIViewController {
    
    // MARK: - 属性
    let YYEmoticonViewControllerIdentifier = "YYEmoticonViewControllerIdentifier"
    
    /// 控制器的textView
    weak var textView: UITextView?
    
    // MARK: - viewDidLoad方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 准备UI
        prepareUI()
        //view.backgroundColor = UIColor.redColor()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        let views = ["cv":collectionView,"tb":toolBar]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束
        // collectionView水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // toolView水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 设置toolbar
        setupToolBar()
        
        // 设置collectionView
        setupCollectionView()
    }
    
    // 设置toolbar
    private func setupToolBar() {
        // 记录按钮点击
        var index = 0
        
        // 创建UIBarButtonItem数组
        var items = [UIBarButtonItem]()
        // 根据加载到的表情包遍历标题数组
        // for name in ["最近","默认","Emoji","浪小花"] {
        for package in packages {
            
            // 获取表情包名称
            let name = package.group_name_cn
            let button = UIButton()
            // 设置按钮标题
            button.setTitle(name, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            button.sizeToFit()
            // tag加上起始值 = 1000 ~ 1003
            button.tag = index + baseTag
            if index == 0 {
                // 让"最近"按钮成为高亮
                switchSelectedButton(button)
            }
            // 添加点击事件
            button.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // 创建 UIBarButtonItem
            let item = UIBarButtonItem(customView: button)
            // 添加到UIBarButtonItem数组
            items.append(item)
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            index++
        }
        // 移除最后的弹簧
        items.removeLast()
        // 设置toolBar的items
        toolBar.items = items
    }
    
    /// 起始的基准tag
    private var baseTag = 1000
    
    /// 记录当前选中的按钮
    private var selectedButton: UIButton?
    
    // 监听按钮
    func buttonClick(button: UIButton) {
        // 获取到当前组的indexPath(0 ~ 3), button.tag(1000 ~ 1003)需要减掉baseTag
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        /**
        让collectionView滚动到指定的位置
        - parameter indexPath:      要显示的cell的indexPath
        - parameter animated:       是否动画
        - parameter scrollPosition: 要滚动的方向(位置)
        */
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        // 设置选中的按钮成为高亮
        switchSelectedButton(button)
    }
    
    // 设置选中的按钮成为高亮
    private func switchSelectedButton(button: UIButton) {
        // 取消之前选中的按钮
        selectedButton?.selected = false
        // 让点击的按钮选中
        button.selected = true
        // 将点击的按钮赋值给选中的按钮
        selectedButton = button
    }
    
    
    // 设置collectionView
    private func setupCollectionView() {
        // 设置代理
        collectionView.delegate = self
        // 设置数据源
        collectionView.dataSource = self
        // 设置随机背景颜色
        collectionView.backgroundColor = UIColor.randomColor()
        // 注册系统的cell
        collectionView.registerClass(YYEmoticonCell.self, forCellWithReuseIdentifier: YYEmoticonViewControllerIdentifier)
    }
    
    // MARK: - 懒加载
    /// collectionView
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: YYCollectionViewFlowLayout())
    /// toolBar
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        //toolBar.backgroundColor = UIColor.randomColor()
        return toolBar
    }()
    
    /// 表情包模型,直接加载内存中的表情包
    private lazy var packages = YYEmoticonPackage.packages
    
}

// MARK: - 扩展YYEmoticonViewController
extension YYEmoticonViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    // 返回表情包的组(一个表情包为一组)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    // 返回cell的数量(每组中表情数量不一样)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // packages[section] 获取对应的表情包
        // packages[section].emoticons?.count 获取对应表情包中的表情数量
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 创建自定义的cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YYEmoticonViewControllerIdentifier, forIndexPath: indexPath) as! YYEmoticonCell
        //cell.backgroundColor = UIColor.randomColor()
        // 获取对应的表情模型
        let emoticon = packages[indexPath.section].emoticons?[indexPath.item]
        // 赋值cell的表情模型
        cell.emoticon = emoticon
        return cell
    }
    
    // 监听scrollView的滚动,当停下来的时候判断当前显示的是那个section
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取到正在显示的section -> indexPath
        // 获取到collectionView正在(first)显示的cell的indexPath
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            // 获取到tooBar的按钮,按钮和section的位置是对应的
            let button = toolBar.viewWithTag(indexPath.section + baseTag) as! UIButton
            // 设置选中的按钮成为高亮
            switchSelectedButton(button)
        }
    }
    
    /*
    将点击的表情插入到textView中
    1. 获取到textView
    2. 需要知道点击的是哪个表情
    */
    /// 监听collectionView的cell的点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 获取到表情添加到textView
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        print("点击的表情是: \(emoticon)")
        
        // 添加表情
        textView?.insertEmoticon(emoticon)
        
        // 当点击"最近"里的表情,发现点击的和添加到textView上的不是同一个表情
        // 原因是数据发生改变,但显示没有变化.  解决方案1: 刷新collectionView的数据(不可取)
        //collectionView.reloadSections(NSIndexSet(index: indexPath.section))
        
        // 解决方案2: 当点击的是最近表情包的表情,不添加到"最近"表情包和排序
        if indexPath.section != 0 {
            // 添加 表情模型 到 "最近"表情包
            YYEmoticonPackage.addFavorite(emoticon)
        }
    }
    
}


// 在collectionView布局之前设置layout的参数
// MARK: - 自定义流水布局,继承自UICollectionViewFlowLayout
class YYCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // 重写UICollectionViewLayout的prepareLayout()方法
    // 布局所在的collectionView
    override func prepareLayout() {
        super.prepareLayout()
        
        let width = collectionView!.frame.width / 7.0
        let height = collectionView!.frame.height / 3.0
        
        // 设置layout的itemSize
        itemSize = CGSize(width: width, height: height)
        
        // 设置分页
        collectionView?.pagingEnabled = true
        // 设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // 取消弹簧效果
        collectionView?.bounces = false
        collectionView?.alwaysBounceHorizontal = false
        // 取消水平滚动条
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
}
