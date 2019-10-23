//
//  PushAnimation.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

enum AnimatorType {
    case kAnimatorTransitionTypePush
    case kAnimatorTransitionTypePop
}

class PushAnimation: NSObject {
    var aniType : AnimatorType?
    
    var transContext : UIViewControllerContextTransitioning?
    var containerV : UIView?
    
    var fromVC : UIViewController?
    var toVC : UIViewController?
    
    var fromV : UIView?
    var toV : UIView?
    
    var itemSize : CGSize?
    var itemCenter : CGPoint?
    var image : UIImage?

}

extension PushAnimation : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        transContext = transitionContext
        containerV = transitionContext.containerView
        
        fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        fromV = transitionContext.view(forKey: UITransitionContextViewKey.from)
        toV = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        if aniType == .kAnimatorTransitionTypePush {
            puchAnimation()
        }else if aniType == .kAnimatorTransitionTypePop {
            popAnimation()
        }

    }
    
    func puchAnimation(){
        containerV?.backgroundColor = self.toV?.backgroundColor
        
        let imageV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        imageV.image = image
        imageV.contentMode = UIViewContentMode.scaleAspectFit
        
        containerV?.addSubview(imageV)
        imageV.center = itemCenter!
        
        let initialScale = (itemSize?.width)! / imageV.frame.width
        imageV.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        
        toV?.frame = (transContext?.finalFrame(for: toVC!))!
        containerV?.addSubview(toV!)
        let finalCenter = toV?.center
        toV?.center = finalCenter!
        toV?.alpha = 0.01
        
        let duration = transitionDuration(using: transContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {[weak self]()in
            imageV.transform = CGAffineTransform.identity
            imageV.center = finalCenter!
            self?.fromV?.alpha = 0.01
        }) { [weak self](finished) in
            imageV.removeFromSuperview()
            self?.fromV?.alpha = 1
            self?.toV?.alpha = 1
            self?.transContext?.completeTransition(!(self?.transContext?.transitionWasCancelled)!)
        }
    }
    
    func popAnimation(){
        toV?.frame = (transContext?.finalFrame(for: toVC!))!
        containerV?.insertSubview(toV!, belowSubview: fromV!)
        toV?.alpha = 0.01
        fromV?.backgroundColor = UIColor.clear
        let duration = transitionDuration(using: transContext)
        UIView.animate(withDuration: duration, animations: { [weak self]()in
            let initialScale = (self?.itemSize?.width)! / SCREEN_WIDTH
            self?.fromV?.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
            self?.fromV?.center = (self?.itemCenter)!
            self?.toV?.alpha = 1
        }) { [weak self](finished) in
            self?.fromV?.alpha = 0.01
            self?.transContext?.completeTransition(!(self?.transContext?.transitionWasCancelled)!)
        }

    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        HCPrint(message: "动画结束！")
    }
}
