//
//  PopoverAnimator.swift
//  DSWB
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    // MARK:- 属性
    fileprivate var isPresented : Bool = false
    var presentedFrame : CGRect = CGRect.zero
}

extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = CoverPresentationController(presentedViewController: presented, presenting: presenting)
        
        presentationController.presentedFrame = presentedFrame
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        
        return self
    }
}

extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // UITransitionContextFromViewKey : 如果是消失动画,则通过该key获取到View
        // UITransitionContextToViewKey : 如果是弹出动画,则通过该key获取到View
        
        isPresented ? presentedAnimation(transitionContext) : dismissAnimation(transitionContext)
    }
    
    
    // MARK:- 执行动画代码
    fileprivate func presentedAnimation(_ transitionContext : UIViewControllerContextTransitioning) {
        // 1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2.将弹出的View添加到容器视图
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                transitionContext.completeTransition(true)
        }) 
    }
    
    fileprivate func dismissAnimation(_ transitionContext : UIViewControllerContextTransitioning) {
        // 1.取出消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00000001)
            }, completion: { (_) -> Void in
                dismissView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }) 
    }
}

