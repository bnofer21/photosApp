//
//  Transition.swift
//  transition
//
//  Created by Юрий on 15.12.2022.
//

import UIKit

enum Transition {
    case present
    case dismiss
}

final class TransitionClass: NSObject {
    
    private var animationView = UIView()
    
    public var circleColor: UIColor = .white
    public var duration = 0.3
    public var mode: Transition = .present
    public var startPoint = CGPoint.zero {
        didSet {
            animationView.center = startPoint
        }
    }
    
    private func frameForCircle(size: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, size.width-startPoint.x)
        let yLength = fmax(startPoint.y, size.width-startPoint.y)
        
        let offsetVector = sqrt(xLength*yLength)*2
        let size = CGSize(width: offsetVector, height: offsetVector)
        return CGRect(origin: .zero, size: size)
    }
}

extension TransitionClass: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if mode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                animationView = UIView()
                animationView.frame = frameForCircle(size: viewSize, startPoint: startPoint)
                animationView.center = startPoint
                animationView.backgroundColor = circleColor
                animationView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(animationView)
                
                presentedView.center = startPoint
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.animationView.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                }) { success in
                    transitionContext.completeTransition(success)
                }
            }
        } else {
            if let returnedView = transitionContext.view(forKey: .from) {
                let viewSize = returnedView.frame.size
                
                animationView.frame = frameForCircle(size: viewSize, startPoint: startPoint)
                animationView.layer.cornerRadius = animationView.frame.width/2
                animationView.center = startPoint
                
                if let initialView = transitionContext.view(forKey: .to) {
                    containerView.insertSubview(initialView, belowSubview: animationView)
                }
                
                UIView.animate(withDuration: duration, animations: {
                    self.animationView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnedView.center = self.startPoint
                    returnedView.alpha = 0
                }) { success in
                    returnedView.removeFromSuperview()
                    self.animationView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
    
}
