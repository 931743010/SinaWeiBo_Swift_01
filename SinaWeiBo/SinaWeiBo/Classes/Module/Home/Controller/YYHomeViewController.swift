//
//  YYHomeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/26.
//  Copyright © 2015年 Arvin. All rights reserved.

// [首页]控制器

import UIKit
import SVProgressHUD

/// 枚举,统一管理Cell的重用Identifier
enum YYStatusRegisterCell: String {
    case YYStatusNormalCell = "YYStatusNormalCell"
    case YYStatusForwardCell = "YYStatusForwardCell"
}

class YYHomeViewController: YYBaseViewController {
    
    // MARK: - 微博模型数组
    private var statuses: [YYStatus]? {
        didSet {
            // 刷新tableView
            tableView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 判断用户是否登录
        if !YYUserAccount.userLogin() {
            // 没有登录,直接return
            return
        }
        
        // 设置首页导航栏
        setupNavigationItem()
        // 准备tableViewCell
        prepareTableViewCell()
        
        ///
        /// 获取微博数据
        ///
        YYStatus.loadStatus { (statuses, error) -> () in
            // 网络加载错误
            if error != nil {
                SVProgressHUD.showErrorWithStatus("加载微博数据失败", maskType: SVProgressHUDMaskType.Gradient)
                return
            }
            // 没有错误,也没有数据
            if statuses == nil || statuses?.count == 0 {
                SVProgressHUD.showErrorWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Gradient)
                return
            }
            // 有数据,赋值给微博模型数组
            self.statuses = statuses
            print("statuses: \(statuses)")
        }
    }
    
    ///
    //  MARK: - 准备tableViewCell
    ///
    func prepareTableViewCell() {
        // 注册原创微博cell
        tableView.registerClass(YYStatusNormalCell.self, forCellReuseIdentifier: YYStatusRegisterCell.YYStatusNormalCell.rawValue)
        // 注册转发微博的cell
        tableView.registerClass(YYStatusForwardCell.self, forCellReuseIdentifier: YYStatusRegisterCell.YYStatusForwardCell.rawValue)
        
        // 预估cell的行高,需要尽量准确,不能太小
        tableView.estimatedRowHeight = 300
        
        // 去掉tableView点击的后的背景色
        tableView.allowsSelection = false
        
        // 去掉tableView的分隔线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 当配图的高度约束改变后,添加contentView底部与bottomView底部重合
        // 会导致系统计算cell高度约束出错,所以不能让系统根据子控件的约束来计算contentView的高度约束
        // tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    ///
    //  MARK: - tableView 代理和数据源方法
    ///
    ///
    /// 返回cell的高度,每次调用都会计算行高,比较耗性能,需要缓存行高到模型中
    ///
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 使用此方法获取cell会再次调用[返回cell的高度]的方法,造成死循环
        // tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // 获取Satatus模型
        let status = statuses![indexPath.row]
        
        // 如果模型中有缓存的行高,则不再计算直接返回
        if let rowHeight = status.rowHeight {
            // print("返回:\(indexPath.row) cell的高度:\(rowHeight)")
            return rowHeight
        }
        
        // 获取注册cell
        // 根据模型的retweeted_status属性来决定注册的是原创微博还是转发微博
        let identifier = status.cellIdentifier()
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! YYStatusCell
        
        let rowHeight = cell.rowHeight(status)
        
        // print("计算:\(indexPath.row) cell的高度:\(rowHeight)")
        
        // 将计算好的行高缓存到模型中
        status.rowHeight = rowHeight
        
        return rowHeight
    }
    
    ///
    /// 返回tableView的行数
    ///
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    ///
    /// 返回tableViewCell
    ///
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取Satatus模型
        let status = statuses![indexPath.row]
        // 获取注册cell
        let cell = tableView.dequeueReusableCellWithIdentifier(status.cellIdentifier()) as! YYStatusCell
        
        // 设置cell的模型
        cell.status = status
        return cell
    }
    
    
//**************************************************************************************//
//**************************************************************************************//
    
    ///
    //  MARK: - 设置首页导航栏
    ///
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        let button = YYHomeTitleView()
        let name = YYUserAccount.loadAccount()?.name ?? "首页"
        button.setTitle(name, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "homeTitleViewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        button.sizeToFit()
        navigationItem.titleView = button
    }
    
    ///
    //  MARK: - 按钮点击事件
    /// swift的方法需要加上 @objc 才能访问OC的方法
    @objc private func homeTitleViewClick(button: UIButton) {
        
        button.selected = !button.selected
        var transform: CGAffineTransform?
        if button.selected {
            // 利用UIView动画(就近原则)特征,使箭头逆向旋转
            transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.001))
        } else {
            // 重置箭头状态
            transform = CGAffineTransformIdentity
        }   // UIView动画
        UIView.animateWithDuration(0.25) { () -> Void in
            button.imageView?.transform = transform!
        }
    }
}
