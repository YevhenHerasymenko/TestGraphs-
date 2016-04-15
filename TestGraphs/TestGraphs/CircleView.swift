//
//  CircleView.swift
//  TestGraphs
//
//  Created by Yevhen Herasymenko on 4/15/16.
//  Copyright © 2016 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewHeight: NSLayoutConstraint!
    
    @IBInspectable var strokeFullColor: UIColor! {
        didSet {
            fullLayer.strokeColor = self.strokeFullColor.CGColor
        }
    }
    
    @IBInspectable var strokeLessLoadedColor: UIColor!
    @IBInspectable var strokeMidLoadedColor: UIColor!
    @IBInspectable var strokeFullLoadedColor: UIColor!
    
    @IBInspectable var lineWidth: NSNumber! {
        didSet {
            let floatWidth = CGFloat(lineWidth)
            fullLayer.lineWidth = floatWidth
            loadedLayer.lineWidth = floatWidth
            lineViewHeight.constant = floatWidth*1.1
            layoutIfNeeded()
        }
    }
    
    let whiteSpaceWidth = 2
    
    var loadedState: CGFloat = 0 {
        didSet {
            stateChangeAnimation()
        }
    }
    
    var fillLineColor: CGColor {
        guard loadedState > 0 else {
            return UIColor.clearColor().CGColor
        }
        switch loadedState {
        case _ where loadedState < 0.4:
            return strokeLessLoadedColor.CGColor
        case _ where loadedState < 0.7:
            return strokeMidLoadedColor.CGColor
        default:
            return strokeFullLoadedColor.CGColor
        }
    }

    lazy var fullLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.view.layer.insertSublayer(layer, below: self.lineView.layer)
        layer.strokeEnd = 1
        return layer
    }()
    
    lazy var loadedLayer: CAShapeLayer =  {
        let layer = self.shapeLayer
        self.view.layer.insertSublayer(layer, below: self.lineView.layer)
        layer.strokeColor = self.fillLineColor
        layer.strokeEnd = 0
        return layer
    }()
    var shapeLayer: CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath(arcCenter:CGPointMake(self.bounds.midX,self.bounds.midX), radius:self.bounds.midX - CGFloat(self.lineWidth)/2, startAngle: CGFloat(M_PI - M_PI/6), endAngle:CGFloat(M_PI/6), clockwise: true)
        layer.path = path.CGPath
        layer.fillColor = UIColor.clearColor().CGColor
        
        layer.strokeStart = 0
        return layer
    }
    
    var basicAnimation: CABasicAnimation {
        let animation = CABasicAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.removedOnCompletion = false
        animation.duration = 2
        return animation
    }
    
    var pathLayerAnimation: CABasicAnimation {
        let animation = basicAnimation
        animation.keyPath = "strokeEnd"
        animation.fromValue = loadedLayer.strokeEnd
        animation.toValue = loadedState
        return animation
    }
    
    var colorLayerAnimation: CABasicAnimation {
        let animation = basicAnimation
        animation.keyPath = "strokeColor"
        animation.fromValue = loadedLayer.strokeColor
        animation.toValue = fillLineColor
        return animation
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed(String(CircleView), owner: self, options: nil)[0] as! UIView
        addSubview(view)
        view.frame = bounds
    }
    
    
    func stateChangeAnimation() {
        CATransaction.begin()
        let pathAnimation = pathLayerAnimation
        let colorAnimation = colorLayerAnimation

        loadedLayer.strokeEnd = loadedState
        loadedLayer.strokeColor = fillLineColor
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, colorAnimation]
        animationGroup.duration = 2
        
        loadedLayer.addAnimation(animationGroup, forKey: "loadedLayerAnimations")
        CATransaction.commit()
    }

}
