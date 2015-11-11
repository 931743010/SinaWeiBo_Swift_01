//
//  YYComposeViewController.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/5.
//  Copyright © 2015年 Arvin. All rights reserved.

// 发送微博控制器

import UIKit
import SVProgressHUD

class YYComposeViewController: UIViewController {
    
    // MARK: - 约束属性
    private var tooBarBottomCon: NSLayoutConstraint?
    
    // 照片选择器的底部约束
    private var photoSelectorViewBttomCons: NSLayoutConstraint?
    
    // 设置微博内容的最大长度
    private let maxStatusLength = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // 背景色
        view.backgroundColor = UIColor.whiteColor()
        
        // 监听键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    /*
    name = UIKeyboardDidChangeFrameNotification; 
    userInfo = {
        UIKeyboardAnimationCurveUserInfoKey = 7;
        UIKeyboardAnimationDurationUserInfoKey = "0.25";
        UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
        UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
        UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
        UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
        UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
        UIKeyboardIsLocalUserInfoKey = 1;
    }*/
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print(self,"挂了")
    }
    
    // 键盘改变的通知
    func willChangeFrame(notification: NSNotification) {
        //print("notification: \(notification)")
        // 键盘结束时的frame
        let endFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        // 键盘的动画时间
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 更新tooBar的底部约束
        tooBarBottomCon?.constant = -(UIScreen.height() - endFrame.origin.y)
        // 开始动画
        UIView.animateWithDuration(duration) { () -> Void in
            //self.tooBar.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    /// 准备UI
    private func prepareUI() {
        view.addSubview(textView)
        view.addSubview(photoSelectorVC.view)
        view.addSubview(tooBar)
        view.addSubview(lengthTipLabel)
        
        setupNavigationBar()
        setupTextView()
        preparePhotoSelectorView()
        setupToolBar()
        prepareStatusLabel()
        
    }
    
    /// 设置导航栏按钮
    private func setupNavigationBar() {
        // 左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtn")
        // 右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        // 设置按钮不可用
        navigationItem.rightBarButtonItem?.enabled = false
        // 设置导航栏标题
        setupTitleView()
    }
    
    /// 设置导航栏标题
    private func setupTitleView() {
    
        let prefix = "撰写微博"
        if let name = YYUserAccount.loadAccount()?.name {
            let titleName = prefix + "\n" + name
            
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(16)
            label.textAlignment = NSTextAlignment.Center
            // 可变字符串
            let attString = NSMutableAttributedString(string: titleName)
            // 转换成OC字符串获取name的范围
            let nameRange = (titleName as NSString).rangeOfString(name)
            // 设置范围内的字体大小/颜色
            attString.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14),NSForegroundColorAttributeName:UIColor.darkGrayColor()], range: nameRange)
            // 将可变字符串赋值给属性文本
            label.attributedText = attString
            label.sizeToFit()
            navigationItem.titleView = label
            
        } else {
            // 没有用户名
            navigationItem.title = prefix
        }
    }
    
    /// 设置tooBar
    private func setupToolBar() {
        
        // 添加约束
        let cons = tooBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        // 获取tooBar的底部约束
        tooBarBottomCon = tooBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 创建tooBar的item数组
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片
        let itemSettings = [
            ["imageName":"compose_toolbar_picture","action":"pictureButton"],
            ["imageName":"compose_trendbutton_background","action":"trendButton"],
            ["imageName":"compose_mentionbutton_background","action":"mentionButton"],
            ["imageName":"compose_emoticonbutton_background","action":"emoticonButton"],
            ["imageName":"compose_addbutton_background","action":"addButton"]]
        
        var index = 0
        // 遍历itemSettings获取图片
        for dict in itemSettings {
            
            let action = dict["action"]!
            let imageName = dict["imageName"]!
            
            // 设置item的图片
            let item = UIBarButtonItem(imageName: imageName)
            
            // 获取item的按钮
            let button = (item.customView as! UIButton)
            // 添加按钮点击事件
            button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 记录按钮tag值
            // button.tag = index
            
            // 添加到tooBar数组中
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
        }
        
        // 移除最后一个弹簧
        items.removeLast()
        // 赋值给tooBar的items
        tooBar.items = items
    }
    
    /// 设置自定义textView
    private func setupTextView() {
        //textView.backgroundColor = UIColor.brownColor()
        // 添加约束
        // 相对于控制器view的内部左上角
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        // 相对于tooBar的顶部右上角
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: tooBar, size: nil)
    }
    
    /// 准备显示微博内容剩余长度的label
    private func prepareStatusLabel() {
   
        // 添加约束
        lengthTipLabel.ff_AlignVertical(type: ff_AlignType.TopRight, referView: tooBar, size: nil, offset: CGPoint(x: -8, y: -8))
    }
    
    /// 准备照片选择器控制器
    private func preparePhotoSelectorView() {
        // 添加子控件
        let photoSelectorView = photoSelectorVC.view

        
        // 添加约束
        let views = ["psv":photoSelectorView,"tb":tooBar]
        photoSelectorView.translatesAutoresizingMaskIntoConstraints = false
        
        // 水平约束
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[psv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views ))
        
        // 垂直约束
        //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-160-[psv(190)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        //photoSelectorView.ff_AlignVertical(type: ff_AlignType.BottomRight, referView: view, size: <#T##CGSize?#>)
        
        // 高度约束
        view.addConstraint(NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.7, constant: 0))
        // 底部重合
        photoSelectorViewBttomCons = NSLayoutConstraint(item: photoSelectorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: view.frame.height * 0.7)
        view.addConstraint(photoSelectorViewBttomCons!)
        
    }
    
    
    // MARK: - 按钮点击事件
    /// 图片按钮
    func pictureButton() {
        print("--图片")
        // 点击图片按钮后让照片选择器View弹上来
        photoSelectorViewBttomCons?.constant = 0
        // 键盘退下去
        textView.resignFirstResponder()
        // 动画效果
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }
    /// #号按钮
    func trendButton() {
        print("--井号")
    }
    /// @符号按钮
    func mentionButton() {
        print("--@符号")
    }
    /// 表情按钮
    func emoticonButton() {
        
        // 1. 当textView.inputView == nil,弹出的是系统的键盘
        // 2. 需要在弹出来之前判断使用什么键盘
        // 先让键盘弾下去
        textView.resignFirstResponder()
        
        // 延时0.15s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(150 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            // 如果inputView == nil,使用的是系统的键盘,切换到表情键盘
            // 如果inputView != nil,使用的是表情键盘,切换到系统的键盘
            self.textView.inputView = self.textView.inputView == nil ? self.emoticonVC.view : nil
            // 弹出键盘
            self.textView.becomeFirstResponder()
        }
    }
    
    /// 加号按钮
    func addButton() {
        print("--加号")
    }
    
    /// 发送微博按钮
    func sendStatus() {
        
        // 获取文本内容/可以带表情图片的文本
        let text = textView.emoticonText()
        
        // 判断微博的内容长度是否 < 0,提示用户不能发送
        let statusLength = text.characters.count
        if maxStatusLength - statusLength < 0 {
            SVProgressHUD.showErrorWithStatus("微博长度超出限制", maskType: SVProgressHUDMaskType.Gradient)
            textView.resignFirstResponder()
            return
        }
        // 获取照片选择器中的图片
        let image = photoSelectorVC.photos.first
        
        // 显示发布微博的状态
        SVProgressHUD.showWithStatus("正在发布微博", maskType: SVProgressHUDMaskType.Gradient)
        
        // 调用网络工具发送微博
        YYNetworkTools.sharedInstance.sendStatus(image, status: text) { (result, error) -> () in
            if error != nil {
                SVProgressHUD.showErrorWithStatus("微博发布失败", maskType: SVProgressHUDMaskType.Gradient)
                //self.textView.resignFirstResponder()
            }
        }
        // 发送成功,关闭控制器
        self.cancelBtn()
        
    }
    
    /// 重写viewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 当照片选择器没有显示的时候才弹出键盘
        if photoSelectorViewBttomCons?.constant != 0 {
            // 让textView成为第一响应者
            textView.becomeFirstResponder()
        }
    }
    
    /// 取消按钮
    @objc private func cancelBtn() {
        //view.endEditing(true)
        
        // 关闭 SVProgressHUD 的显示状态
        SVProgressHUD.dismiss()
        
        // 让textView失去第一响应者
        textView.resignFirstResponder()
        
        // 返回来源控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - 懒加载
    private lazy var tooBar: UIToolbar = {
        let tooBar = UIToolbar()
        tooBar.backgroundColor = UIColor(white: 0.7, alpha: 1)
        return tooBar
    }()
    
    
    /// 自定义textView
    private lazy var textView: YYPlaceholderTextView = {
        // 创建自定义textView
        let textView = YYPlaceholderTextView()
        
        // 设置textView的顶部偏移
        //textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // 当textView被拖动的时候就会将键盘自动隐藏,前提是textView可以拖动
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        textView.textColor = UIColor.blackColor()
        textView.font = UIFont.systemFontOfSize(16)
    
        //textView.bounces = true
        // 设置垂直方向拖动的弹簧效果
        textView.alwaysBounceVertical = true
        
        // 设置占位文本
        textView.placeholderText = "#分享新鲜事..."
        // 设置代理
        textView.delegate = self
        
        return textView
    }()
    
    /// 懒加载表情键盘控制器
    private lazy var emoticonVC: YYEmoticonViewController = {
       let controller = YYEmoticonViewController()
        // 设置控制器的textView
        controller.textView = self.textView
        return controller
    }()
    
    /// 显示微博内容长度的label
    private lazy var lengthTipLabel: UILabel = {
        let label = UILabel(fontSize: 12, textColor: UIColor.lightGrayColor())
        //label.backgroundColor = UIColor.randomColor()
        label.text = String(self.maxStatusLength)
        return label
    }()
    
    
    /// 懒加载照片选择器控制器
    private lazy var photoSelectorVC: YYPhotoSelectorViewController = {
        let controller = YYPhotoSelectorViewController()
        // 添加给外面的控制器管理
        self.addChildViewController(controller)
        return controller
    }()
    
}


// MARK: - 扩展,实现 UITextViewDelegate 代理方法
extension YYComposeViewController: UITextViewDelegate {
    // textView文本改变的时候调用
    func textViewDidChange(textView: UITextView) {
        // 当textView有输入文本的时候,发送按钮可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()

        // 获取textView中输入的文本内容的长度
        let statusLength = textView.emoticonText().characters.count
        // 计算剩余长度
        let length = maxStatusLength - statusLength
        // 重新赋值lebelde的内容
        lengthTipLabel.text = String(length)
        // 如果微博内容长度小于0,显示红色的文本
        lengthTipLabel.textColor = length >= 0 ? UIColor.lightGrayColor() : UIColor.redColor()
    }
    
}


/// 代码备份
private func backup_3() {
    /*
    func itemAction(button: UIButton) {
    switch button.tag {
    case 0:
    print("图片:\(button.tag)")
    case 1:
    print("井号:\(button.tag)")
    case 2:
    print("@符号:\(button.tag)")
    case 3:
    print("表情:\(button.tag)")
    case 4:
    print("加号:\(button.tag)")
    default:
    print("xxoo")
    }
    }*/

}
