//
//  YYHomeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/26.
//  Copyright © 2015年 Arvin. All rights reserved.

// [首页]控制器
/*
1. tableFooterView只显示一半?
2. loadStatusData重复调用两次
3. 获取到的新微博会显示2条
4. 每次运行程序自动刷新时,会显示系统菊花
*/

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
        
        // TODO: 在这设置下拉刷新
        /// 自定义刷新控件,并添加自定义的view
        refreshControl = YYRefreshControl()
        refreshControl?.tintColor = UIColor.clearColor()
        
        // 获取微博数据
        // loadStatusData()
        
        // 注册下拉刷新的监听事件,获取微博数据
        refreshControl?.addTarget(self, action: "loadStatusData", forControlEvents: UIControlEvents.ValueChanged)
        
        // MARK: 进入界面主动刷新
        // 先调用父类开始刷新的方法,进入刷新状态,但不会触发ValueChanged事件
        refreshControl?.beginRefreshing()
        // 再调用[sendActionsForControlEvents]方法才能触发refreshControl的ValueChanged事件
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    ///
    /// 获取微博数据
    ///
    func loadStatusData() {
        
        print("开始加载微博数据")
        /// 默认下拉刷新,获取到最新的(ID最大)微博,如果没有数据,默认加载20条
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 如果指示器正在显示,表示正在上拉获取数据
        if pullUpView.isAnimating() {
            // 上拉不加载新的id
            since_id = 0
            // 将max_id设置成最后一条微博的id
            max_id = statuses?.last?.id ?? 0
        }
        
        YYStatus.loadStatus (since_id, max_id: max_id){ (statuses, error) -> () in
            // TODO: 结束下拉刷新,重写了父类方法
            self.refreshControl?.endRefreshing()
            // 停止指示器
            self.pullUpView.stopAnimating()
            
            // 网络加载错误
            if error != nil {
                //SVProgressHUD.showErrorWithStatus("加载微博数据失败", maskType: SVProgressHUDMaskType.Gradient)
                return
            }
            
            if since_id > 0 {
                let count = statuses?.count ?? 0
                self.showTipView(count)
            }
            
            if statuses == nil || statuses?.count == 0 {
                return
            }
            
            // 网络没有错误
//            if statuses == nil || since_id > 0 {
//                // 获取到刷新的微博数量
//                let count = statuses?.count ?? 0
//                print("count: \(count)")
//                self.showTipView(count)
//                // return
//            }
            
            if since_id > 0 {
                
                // 最新数据 = 新获取到的数据 + 原有数据
                // 下拉刷新,将最新的微博拼接在原有微博的前面
                self.statuses = statuses! + self.statuses!
                print("下拉刷新到: \(statuses?.count)条微博")
                
            } else if max_id > 0 {
                
                // 最新数据 = 原有数据 + 新获取到的数据
                // 上拉刷新,将原有微博拼接到最新微博的后面
                self.statuses = self.statuses! + statuses!
                print("上拉加载到: \(statuses?.count)条微博")
                
            } else {
                
                // 有数据,默认加载20条微博赋值给模型数组
                self.statuses = statuses
                print("最新获取到: \(statuses?.count)条微博")
            }
        }
    }
    
    /// 显示加载的微博数量
    private func showTipView(count: Int) {
        
        let tipLabel = UILabel()
        let tipLabelHeight: CGFloat = 44
        tipLabel.frame = CGRect(x: 0, y: -20 - tipLabelHeight, width: UIScreen.width(), height: tipLabelHeight)
        
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = NSTextAlignment.Center
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.text = count != 0 ? "\(count)条新的微博" : "没有新的微博"
        
        // 将label添加到导航栏的最下面
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        // 开始动画
        let dutrtion = 0.5
        UIView.animateWithDuration(dutrtion, animations: { () -> Void in
            // UIView.setAnimationRepeatAutoreverses(true)  动画反过来执行
            // UIView.setAnimationRepeatCount(3)  重复执行指定的动画次数
            tipLabel.frame.origin.y = tipLabelHeight
            }) { (_) -> Void in
                UIView.animateWithDuration(dutrtion, delay: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    tipLabel.frame.origin.y = -20 - tipLabelHeight
                    }, completion: { (_) -> Void in
                        tipLabel.removeFromSuperview()
                })
        }
        
    }
    
    
    ///
    //  MARK: - 准备tableViewCell
    ///
    func prepareTableViewCell() {
        
        // 添加footerView,上拉刷新时显示的指示器
        tableView.tableFooterView = pullUpView
        //tableView.tableFooterView?.backgroundColor = UIColor.orangeColor()
        //print("底部View:\(tableView.tableFooterView?.frame)")
        
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
    ///
    //  MARK: - tableView 代理和数据源方法
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
        
        // 当最后一个cell显示的时候,加载更多数据
        // 如果指示器正在显示,表示正在加载数据,则不重复加载
        if indexPath.row == statuses!.count - 1 && !pullUpView.isAnimating(){
            // 开启指示器
            pullUpView.startAnimating()
            // 上拉加载更多数据
            //loadStatusData()
        }
        return cell
    }
    
    // MARK: - 懒加载
    /// 上拉加载更多数据时显示的指示器
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.color = UIColor.darkGrayColor()
        return indicator
    }()
    
    
    
//**************************************************************************************//
//**************************************************************************************//
    
    ///
    //  MARK: - 设置首页导航栏
    ///
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        let button = YYHomeTitleViewButton()
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
