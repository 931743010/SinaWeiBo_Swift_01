//
//  YYRefreshControl.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/3.
//  Copyright © 2015年 Arvin. All rights reserved.

// 刷新控制器

import UIKit

class YYRefreshControl: UIRefreshControl {
    
    // MARK: - 属性
    // 标记, 用于去除重复调用
    private var isUp = false
    
    // 根据这个值来改变箭头方向
    private let RefreshControlOffset: CGFloat = -50
    
    // 重写父类的frame属性,实现属性监视器
    override var frame: CGRect {
        didSet {
            //print("frame: \(frame)")
            
            // 判断系统的刷新控件是否正在刷新
            if refreshing {
                // 调用自定义的view,开始刷新
                refreshView.startLoading()
            }
            // Y值 >= 0 时,直接返回,啥都不做
            if frame.origin.y >= 0 {
                return
            }
            // Y值小于 -50 并且箭头是向下的(!isUp),使箭头向上
            if frame.origin.y < RefreshControlOffset && !isUp {
                isUp = true
                refreshView.rotationArrowView(isUp, text: "🙈释放更新", textColor: UIColor.orangeColor())
                
            // Y值大于 -50 并且箭头是向上的(isUp),使箭头向下
            } else if frame.origin.y > RefreshControlOffset && isUp {
                isUp = false
                refreshView.rotationArrowView(isUp, text: "🙉下拉刷新", textColor: UIColor.darkGrayColor())
            }
        }
    }
    
    // MARK: 重写父类的停止刷新的方法
    override func endRefreshing() {
        // 先调用父类方法
        super.endRefreshing()        
        // 再调用自定义刷新控件停止刷新
        refreshView.stopLoading()
    }

    
    // MARK: - 构造函数
    override init() {
        super.init()
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(refreshView)
        // 设置背景色
        refreshView.backgroundColor = UIColor.whiteColor()
        // 添加约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }
    
    // MARK: - 懒加载
    // 自定义刷新的view,从xib加载出来就有frame,不需要设置
    private lazy var refreshView: YYRefreshView = YYRefreshView.refreshView()
    
}
