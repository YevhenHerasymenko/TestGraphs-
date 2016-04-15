//
//  CircleView.swift
//  TestGraphs
//
//  Created by Yevhen Herasymenko on 4/15/16.
//  Copyright © 2016 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    @IBInspectable var strokeFullColor: UIColor! {
        didSet {
            let color = strokeFullColor.CGColor
            self.leftPartFullLayer.strokeColor = color
            self.rightPartFullLayer.strokeColor = color
        }
    }
    
    @IBInspectable var strokeLessLoadedColor: UIColor!
    
    @IBInspectable var strokeFullLoadedColor: UIColor!
    
    @IBInspectable var lineWidth: NSNumber! {
        didSet {
            let floatWidth = CGFloat(lineWidth)
            self.leftPartFullLayer.lineWidth = floatWidth
            self.leftPartLoadedLayer.lineWidth = floatWidth
            self.rightPartFullLayer.lineWidth = floatWidth
            self.rightPartLoadedLayer.lineWidth = floatWidth
        }
    }
    
    let whiteSpaceWidth = 2
    
    private var leftLoadedState: CGFloat = 0
    private var rightLoadedState: CGFloat = 0
    
    var loadedState: CGFloat {
        get {
            return (leftLoadedState + rightLoadedState)/2
        }
        set {
            leftLoadedState = newValue > 0.5 ? 1 : newValue*2
            rightLoadedState = newValue < 0.5 ? 0 : (newValue-0.5)*2
            loadedState > 0.5 ? leftBlockAnimation() : rightBlockAnimation()
        }
        
        
    }
    
    var fillLineColor: CGColor {
        guard loadedState > 0 else {
            return UIColor.clearColor().CGColor
        }
        return loadedState > 0.7 ? strokeFullLoadedColor.CGColor : strokeLessLoadedColor.CGColor
    }

    lazy var leftPartFullLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.layer.addSublayer(layer)
        layer.path = self.leftPath
        layer.strokeEnd = 1
        return layer
    }()
    
    lazy var rightPartFullLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.layer.addSublayer(layer)
        layer.path = self.rightPath
        layer.strokeEnd = 1
        return layer
    }()
    
    lazy var leftPartLoadedLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.layer.addSublayer(layer)
        layer.path = self.leftPath
        layer.strokeEnd = 0
        return layer
    }()
    
    lazy var rightPartLoadedLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.layer.addSublayer(layer)
        layer.path = self.rightPath
        layer.strokeEnd = 0
        return layer
    }()
    
    var shapeLayer: CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = fillLineColor
        layer.strokeStart = 0
        return layer
    }

    var leftPath: CGPath {
        let path = UIBezierPath(arcCenter:CGPointMake(self.bounds.midX - CGFloat(whiteSpaceWidth)/2,self.bounds.maxY), radius:self.bounds.height - CGFloat(lineWidth)/2, startAngle: CGFloat(M_PI), endAngle:CGFloat(-M_PI_2), clockwise: true)
        return path.CGPath
    }
    
    var rightPath: CGPath {
        let path = UIBezierPath(arcCenter:CGPointMake(self.bounds.midX + CGFloat(whiteSpaceWidth)/2,self.bounds.maxY), radius:self.bounds.height - CGFloat(lineWidth)/2, startAngle: CGFloat(-M_PI_2), endAngle:0, clockwise: true)
        return path.CGPath
    }
    
    var basicAnimation: CABasicAnimation {
        let animation = CABasicAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.removedOnCompletion = false
        animation.duration = 1
        return animation
    }
    
    var pathAnimation: CABasicAnimation {
        let animation = basicAnimation
        animation.keyPath = "strokeEnd"
        return animation
    }
    
    var leftPathAnimation: CABasicAnimation {
        let animation = pathAnimation
        animation.fromValue = leftPartLoadedLayer.strokeEnd
        animation.toValue = leftLoadedState
        return animation
    }
    
    var rightPathAnimation: CABasicAnimation {
        let animation = pathAnimation
        animation.fromValue = rightPartLoadedLayer.strokeEnd
        animation.toValue = rightLoadedState
        return animation
    }
    
    var colorAnimation: CABasicAnimation {
        let animation = basicAnimation
        animation.keyPath = "strokeAnimation"
        return animation
    }
    
    func leftBlockAnimation() {
        CATransaction.begin()
        let animation = leftPathAnimation
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.loadedState > 0.5 {
                strongSelf.rightBlockAnimation()
            }
        }
        leftPartLoadedLayer.strokeEnd = leftLoadedState
        leftPartLoadedLayer.addAnimation(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
    
    func rightBlockAnimation() {
        CATransaction.begin()
        let pathAnimation = rightPathAnimation
        
        
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.loadedState < 0.5 {
                strongSelf.leftBlockAnimation()
            }
        }
        let rightColorAnimation = colorAnimation
        rightColorAnimation.fromValue = rightPartLoadedLayer.strokeColor
        rightColorAnimation.toValue = fillLineColor
        
        rightPartLoadedLayer.strokeEnd = rightLoadedState
        rightPartLoadedLayer.strokeColor = fillLineColor
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, rightColorAnimation]
        animationGroup.duration = 1
        
        rightPartLoadedLayer.addAnimation(animationGroup, forKey: "rightBlockAnimations")
        
        CATransaction.commit()
        leftColorAnimation()
    }
    
    func leftColorAnimation() {
        CATransaction.begin()
        let leftColorAnimation = colorAnimation
        leftColorAnimation.fromValue = leftPartLoadedLayer.strokeColor
        leftColorAnimation.toValue = fillLineColor
        
        leftPartLoadedLayer.strokeColor = fillLineColor
        leftPartLoadedLayer.addAnimation(leftColorAnimation, forKey: "strokeColor")
        
        CATransaction.commit()
    }

}
