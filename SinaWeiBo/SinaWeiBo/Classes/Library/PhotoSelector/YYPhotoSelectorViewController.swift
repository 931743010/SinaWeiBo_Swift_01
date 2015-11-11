//
//  YYPhotoSelectorViewController.swift
//  照片选择器
//
//  Created by Arvin on 15/11/9.
//  Copyright © 2015年 Arvin. All rights reserved.

// 照片选择控制器

import UIKit

private let reuseIdentifier = "Cell"

class YYPhotoSelectorViewController: UICollectionViewController,YYPhotoSelectorDelegate {
    
    // MARK: - 属性
    // 照片数组
    var photos = [UIImage]()
    
    // 最大照片数
    private let maxPhotoCount = 9
    
    // 记录当前点击的cell的indePath
    var currentIndexPath: NSIndexPath?
    
    // CollectionView 流水布局
    let layout = UICollectionViewFlowLayout()
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // 准备CollecticonView
        prepareCollecticonView()
    }
    
    func prepareCollecticonView() {
        // 设置背景色
        collectionView?.backgroundColor = UIColor.clearColor()
        // 注册自定义cell
        collectionView?.registerClass(YYPhotoSelectorCell.self, forCellWithReuseIdentifier: "cell")
        // 设置itemSize
        layout.itemSize = CGSize(width: 80, height: 80)
        // 设置item之间的间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //  MARK: - CollectionView数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 当照片张数小于最大张数时,返回照片张数+1,否则返回照片张数
        return photos.count < maxPhotoCount ? photos.count + 1 : photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 创建自定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! YYPhotoSelectorCell
        // 指定代理
        cell.cellDelegate = self
        // 设置背景色
        cell.backgroundColor = UIColor.brownColor()
        
        // 当有图片的时候才设置图片
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.item]
        } else {
            // 防止cell被复用,在这重新设置按钮的图片
            cell.setAddbuttonPhoto()
        }
        return cell
    }
    
    // MARK: - YYPhotoSelectorDelegate方法
    // 添加照片
    func photoSelectorCellAddPhoto(cell: YYPhotoSelectorCell) {
        
        // 弹出系统相册,先判断是否可用
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("系统相册不可用")
            return
        }
        
        let picker = UIImagePickerController()
        // 指定代理
        picker.delegate = self
        
        // 记录当前被点击的cell的indexPath
        currentIndexPath = collectionView?.indexPathForCell(cell)
        
        // 跳转到系统相册
        presentViewController(picker, animated: true, completion: nil)
        
    }
    // 删除照片
    func photoSelectorCellRemovePhoto(cell: YYPhotoSelectorCell) {
        
        // 记录当前的点击的cell的indexPath
        let indexPath = collectionView!.indexPathForCell(cell)!
        
        // 删除对应的cell的indexPath的图片
        photos.removeAtIndex(indexPath.item)
        
        // 刷新collectionView
        // collectionView?.reloadData()
        if photos.count < maxPhotoCount - 1 {
            collectionView?.deleteItemsAtIndexPaths([indexPath])
        } else  {
            collectionView?.reloadData()
        }
    }
    
}

// MARK: - 扩展,实现UIImagePickerController的代理方法
extension YYPhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 选择照片的代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("原始图: \(image)")
        
        // 当上传的图片比较大时,需要将其压缩
        let newImage = image.scaleImage()
        
        print("压缩图: \(newImage)")
        
        if currentIndexPath?.item < photos.count {
            // 点击的是图片,替换图片
            photos[currentIndexPath!.item] = newImage
            
        } else {
            // 点击的是加号,获取到照片添加到数组
            photos.append(newImage)
        }
        
        // 添加照片后必须刷新才能显示
        collectionView?.reloadData()
        
        // 关闭系统相册
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - 定义代理方法
protocol YYPhotoSelectorDelegate: NSObjectProtocol {
    // 添加照片
    func photoSelectorCellAddPhoto(cell:YYPhotoSelectorCell)
    // 删除照片
    func photoSelectorCellRemovePhoto(cell:YYPhotoSelectorCell)
}


// MARK: - 自定义cell
class YYPhotoSelectorCell: UICollectionViewCell {
    
    // 定义代理属性
    weak var cellDelegate: YYPhotoSelectorDelegate?
    
    // 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 保存图片到cell
    var image: UIImage? {
        didSet {
            addButton.setImage(image, forState: UIControlState.Normal)
            addButton.setImage(image, forState: UIControlState.Highlighted)
            // 在这显示删除按钮
            removeButton.hidden = false
        }
    }
    
    // 设置加号按钮的图片
    func setAddbuttonPhoto() {
        addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        addButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        // 在这隐藏删除按钮
        removeButton.hidden = true
    }
    
    // 准备UI
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 去掉autoresizing约束
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["ab":addButton,"rb":removeButton]
        
        // 加号按钮约束
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // 删除按钮约束
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[rb]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    // MARK: - 按钮点击事件
    // 添加照片
    func addPhoto() {
        // 通知代理处理
        cellDelegate?.photoSelectorCellAddPhoto(self)
    }
    // 删除照片
    func removePhoto() {
        // 通知代理处理
        cellDelegate?.photoSelectorCellRemovePhoto(self)
    }
    
    // MARK: - 懒加载
    // 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        // 图片填充模式
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        // 设置按钮图片
        button.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "addPhoto", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    // 删除按钮
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        button.addTarget(self, action: "removePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
}



