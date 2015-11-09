//
//  YYRefreshView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/3.
//  Copyright © 2015年 Arvin. All rights reserved.

// 自定义刷新控件

import UIKit

class YYRefreshView: UIView {
    
    /// tipView
    @IBOutlet weak var tipView: UIView!
    /// 文本标签
    @IBOutlet weak var textLabel: UILabel!
    /// 更新时间标签
    @IBOutlet weak var updateLabel: UILabel!
    /// 箭头view
    @IBOutlet weak var arrowView: UIImageView!
    /// 转圈View
    @IBOutlet weak var loadingView: UIImageView!
    
    /// 返回自定义刷新控件
    class func refreshView() -> YYRefreshView {
        return NSBundle.mainBundle().loadNibNamed("YYRefreshView", owner: self, options: nil).last as! YYRefreshView
    }
    
    /// 旋转箭头view
    func rotationArrowView(isUp: Bool, text: String) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.textLabel.text = text
            self.arrowView.transform = isUp ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.001)) : CGAffineTransformIdentity
        }
    }
    
   
    /// 开始刷新
    func startLoading() {
        
        // 添加key,如果动画正在执行,则不再添加动画
        let animKey = "animKey"
        // 找到key对应的动画,如果动画正在执行,直接返回
        if let _ = loadingView.layer.animationForKey(animKey) {
            return
        }
        // 隐藏箭头view
        tipView.hidden = true
        // 使用核心动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.toValue = M_PI * 2
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        loadingView.layer.addAnimation(animation, forKey: animKey)
        
    }
    
    /// 结束刷新
    func stopLoading() {
        // 显示tipView
        tipView.hidden = false
        // 更新时间
        updateLabel.text = updateTime()
        // 移除刷新转圈的动画
        loadingView.layer.removeAllAnimations()
    }
    
    /// 更新刷新时间
    private func updateTime() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        let time = formatter.stringFromDate(NSDate())
        return "更新于:\(time)"
    }
        
}
