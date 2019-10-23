//
//  XMGPresentationController.swift
//  DSWB
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit

//用来包装自定义presentedview
class CoverPresentationController: UIPresentationController {
    
    var presentedFrame : CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        // 2.添加蒙版
        setupCoverView()
    }
}

extension CoverPresentationController {
    /// 添加蒙版
    fileprivate func setupCoverView() {
        // 1.创建蒙版
        let coverView = UIView(frame: containerView!.bounds)
        
        // 2.设置蒙版的颜色
        coverView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        // 3.监听蒙版的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(CoverPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
        
        // 4.将蒙版添加到容器视图中
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
    }
    
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
