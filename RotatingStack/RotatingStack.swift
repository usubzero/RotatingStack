//
//  RotatingStack.swift
//  RotatingStack
//
//  Created by Ethan Fine on 2/16/19.
//  Copyright © 2019 Ethan Fine. All rights reserved.
//

import UIKit

enum AnimationType: String {
    
    case slow = "slowAnimation"
    case fast = "fastAnimation"
    
    func getDuration() -> Double {
        switch self {
        case .slow:
            return 1.0
        case .fast:
            return 0.6
        }
    }
    
    func getRotationAmount() -> Double {
        switch self {
        case .slow:
            return Double.pi
        case .fast:
            return Double.pi
        }
    }
    
}

class RotatingStack: CATransformLayer, CAAnimationDelegate {
    
    let offsetTime = 0.1
    let stackRotation = CGFloat(Double.pi / 3)
    
    let colors = [UIColor.white,
                  UIColor(red:0.87, green:0.89, blue:0.90, alpha:1.0),
                  UIColor(red:0.80, green:0.78, blue:0.80, alpha:1.0),
                  UIColor(red:0.69, green:0.67, blue:0.69, alpha:1.0),
                  UIColor(red:0.58, green:0.57, blue:0.58, alpha:1.0),
                  UIColor(red:0.48, green:0.47, blue:0.48, alpha:1.0)]
    
    init(x: Int, y: Int, width: Int = 50, itemSpacing: Int = 20) {
        super.init()
        
        for i in 0..<6 {
            let item = CALayer()
            item.backgroundColor = colors[5 - i].cgColor
            item.frame = CGRect(x: x, y: y, width: width, height: width)
            item.cornerRadius = CGFloat(width / 4)
            item.zPosition = CGFloat(i * itemSpacing)
            item.shouldRasterize = true
            
            insertSublayer(item, at: 0)
        }
        
        transform = CATransform3DRotate(transform, stackRotation, 1, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Start the animation cycle
    func startAnimating() {
        for (index, item) in sublayers!.enumerated() {
            let beginTime = CACurrentMediaTime() + Double(index) * offsetTime
            animateStackItem(item: item, beginTime: beginTime, animationType: AnimationType.slow)
        }
    }
    
    // Go through one animation cycle of a stack item
    func animateStackItem(item: CALayer, beginTime: CFTimeInterval, animationType: AnimationType) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let beginRotationValue = item.value(forKeyPath: "transform.rotation")
        rotateAnimation.fromValue = beginRotationValue
        rotateAnimation.toValue = (beginRotationValue as! Double) + animationType.getRotationAmount()
        rotateAnimation.duration = animationType.getDuration()
        rotateAnimation.beginTime = beginTime
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.delegate = self
        
        item.add(rotateAnimation, forKey: animationType.rawValue)
    }
    
    // Determine which animation cycle to begin next for a stack item and begin it
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        for item in sublayers! {
            let beginTime = CACurrentMediaTime() + offsetTime * Double(sublayers!.count)
            if anim == item.animation(forKey: AnimationType.slow.rawValue) {
                animateStackItem(item: item, beginTime: beginTime, animationType: AnimationType.fast)
                break
            }
            if anim == item.animation(forKey: AnimationType.fast.rawValue) {
                animateStackItem(item: item, beginTime: beginTime, animationType: AnimationType.slow)
                break
            }
        }
    }
    
}
