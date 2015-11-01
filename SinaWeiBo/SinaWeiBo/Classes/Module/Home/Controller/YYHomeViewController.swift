//
//  YYHomeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/10/26.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        // 注册cell
        tableView.registerClass(YYStatusCell.self, forCellReuseIdentifier: "cell")
        // AutomaticDimension 根据约束自己计算高度
        tableView.rowHeight = UITableViewAutomaticDimension
        // 预估行高
        tableView.estimatedRowHeight = 300
    }
    
    
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
    ///
    @objc private func homeTitleViewClick(button: UIButton) {
        
        button.selected = !button.selected
        var transform: CGAffineTransform?
        if button.selected {
            // 利用UIView动画特征,使箭头逆向旋转
            transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.001))
        } else {
            // 重置箭头状态
            transform = CGAffineTransformIdentity
        }   // UIView动画
        UIView.animateWithDuration(0.25) { () -> Void in
            button.imageView?.transform = transform!
        }
    }
    
    ///
    //  MARK: - tableView 代理和数据源方法
    ///
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取cell,定义重用标识
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! YYStatusCell
        
        // 设置cell的模型
        cell.status = statuses?[indexPath.row]
        
        return cell
    }
    
}






























