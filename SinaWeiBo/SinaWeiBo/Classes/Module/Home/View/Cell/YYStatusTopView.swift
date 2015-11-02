//
//  YYStatusTopView.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/1.
//  Copyright © 2015年 Arvin. All rights reserved.

// 微博自定义Cell的头部View

import UIKit

class YYStatusTopView: UIView {
    ///
    // MARK: - 微博模型属性
    ///
    var status: YYStatus? {
        didSet{
            // 设置用户头像
            if let iconUrl = status?.user?.profile_image_url {
                // 网络加载头像
                iconView.yy_setImageWithURL(NSURL(string: iconUrl))
            }
            nameLabel.text = status?.user?.name                       // 用户昵称
            timeLabel.text = status?.created_at                       // 微博时间
            sourceLabel.text = "来自iphone 6s plus"                    // 微博来源
            mbrankImgView.image = status?.user?.mbrankImage           // 会员等级
            verifiedImgView.image = status?.user?.verified_typeImage  // 认证用户
        }
    }
    
    ///
    // MARK: - 构造函数
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    // MARK: - 准备UI
    ///
    func prepareUI() {
        
        // 添加子控件
        addSubview(topSeparateView)    // 分隔视图
        addSubview(iconView)           // 用户头像
        addSubview(nameLabel)          // 昵称标签
        addSubview(timeLabel)          // 时间标签
        addSubview(sourceLabel)        // 来源标签
        addSubview(mbrankImgView)      // 等级图标
        addSubview(verifiedImgView)    // 认证图标
        
        // 顶部分隔视图
        topSeparateView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 10))
        
        // 用户头像约束
        iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topSeparateView, size: CGSize(width: 35, height: 35), offset: CGPoint(x: 8, y: 8))
        
        // 昵称标签约束
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        
        // 时间标签约束
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        
        // 来源标签约束
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: 8, y: 0))
        
        // 等级图标约束
        mbrankImgView.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 8, y: 0))
        
        // 认证图标约束
        verifiedImgView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset: CGPoint(x: 4.5, y: 4.5))
        
    }
    
    
    //  MARK: - 懒加载
    /// 顶部分隔栏视图
    private lazy var topSeparateView: UIView = {
        let view = UIView()
         view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    /// 用户头像
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.layer.cornerRadius = 17.5
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    /// 用户昵称
    private lazy var nameLabel: UILabel = UILabel(fontSize: 14, textColor: UIColor.darkGrayColor())
    
    /// 微博时间
    private lazy var timeLabel: UILabel = UILabel(fontSize: 9, textColor: UIColor.orangeColor())
    
    /// 微博来源
    private lazy var sourceLabel: UILabel = UILabel(fontSize: 9, textColor: UIColor.lightGrayColor())
    
    /// 会员等级
    private lazy var mbrankImgView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    /// 认证用户
    private lazy var verifiedImgView = UIImageView()
    
}

