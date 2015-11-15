//
//  YYPhotoBrowserCell.swift
//  SinaWeiBo
//
//  Created by Arvin on 15/11/14.
//  Copyright © 2015年 Arvin. All rights reserved.
//

import UIKit

class YYPhotoBrowserCell: UICollectionViewCell {
    
    var url: NSURL? {
        didSet {
            guard let imageUrl = url else {
                print("URL地址为空..")
                return
            }
            // 防止cell复用,重置图片
            imageView.image = nil
            
            // 开启下载指示器
            indicator.startAnimating()
            
            // 从网络下载图片
            self.imageView.sd_setImageWithURL(imageUrl) { (image, error, _, _) -> Void in
                // 关闭下载指示器
                self.indicator.stopAnimating()
                if error != nil {
                    print("下载图片出错..")
                    print("error: \(error),imageURL: \(imageUrl)")
                    return
                }
                // 下载图片成功
                print("下载图片成功")
                self.layoutImageView(image)
                // 设置imageView的frame
                //let newSize = self.displayImageSize(image)
                //self.imageView.frame = CGRect(origin: CGPointZero, size: newSize)
            }
        }
    }
    /*
        根据图片的高度重新布局imageView
        当图片的高度小于屏幕高度时,居中显示
        当图片的高度大于屏幕高度时,全屏显示,并设置滚动
    */
    private func layoutImageView(image: UIImage) {
        // 返回等比例缩放的图片
        let size = displayImageSize(image)
        // 判断长短图
        if size.height < UIScreen.height() {
            // 短图
            let offsetY = ((UIScreen.height() - 80) - size.height) * 0.5
            imageView.frame = CGRect(x: 0, y: offsetY, width: size.width, height: size.height)
        } else {
            // 长图
            imageView.frame = CGRect(origin: CGPointZero, size: size)
            // 设置滚动范围
            scrollView.contentSize = size
        }
    }
    
    // 返回等比例缩放的图片
    private func displayImageSize(image: UIImage) -> CGSize {
        // 计算图片的宽高
        let newWidth = UIScreen.width()
        // 新的宽度/新的高度 = 原来的宽度/原来的高度
        let newHeight = newWidth * image.size.height / image.size.width
        return CGSize(width: newWidth, height: newHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 准备UI
        prepareUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(indicator)
        scrollView.addSubview(imageView)
        
        // 设置scrollView的缩放比例
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 0.5
        // 指定代理
        scrollView.delegate = self
        
        // 添加约束
        //scrollView.backgroundColor = UIColor.redColor()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv":scrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[sv]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sv":scrollView]))
        // 下载指示器
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
    }
    
    // MARK: - 懒加载
    /// scrollView
    private lazy var scrollView = UIScrollView()
    
    /// imangeView
    private lazy var imageView = UIImageView()
    
    /// 下载指示器
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
}

// MARK: - 扩展
extension YYPhotoBrowserCell: UIScrollViewDelegate {
    
    // 返回需要缩放的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // scrollView缩放完毕时调用
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("缩放完毕")
        print("image:\(imageView.transform)")
    }
    
    // scrollView缩放时调用
    func scrollViewDidZoom(scrollView: UIScrollView) {
        print("正在缩放")
    }
}


