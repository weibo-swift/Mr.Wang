//
//  AnimationManager.swift
//  微博
//
//  Created by 王新克 on 2017/6/30.
//  Copyright © 2017年 王新克. All rights reserved.
//

import UIKit

class AnimationManager: NSObject {

     var isPresent : Bool = false
}

extension AnimationManager : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}


extension AnimationManager : UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresent ? animationPresentView(using: transitionContext) : animationDismissView(using: transitionContext)
        
    }
    
    
    //自定义弹出动画
    
    func animationPresentView(using transitionContext: UIViewControllerContextTransitioning) {
        
        //获取弹出的view   注意用.to
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentView)
        
        presentView.transform = CGAffineTransform(a: 20, b: 0, c: 0, d: 0, tx: 0, ty: 0)
        //        presentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
            
            presentView.transform = CGAffineTransform.identity
        }) { (isFinish) in
            transitionContext.completeTransition(true)
        }
        
    }
    
    func animationDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 0.0001, tx: 0, ty: 0)
        }) { (isFinish) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}



