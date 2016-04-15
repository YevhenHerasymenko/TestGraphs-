//
//  CircleView.swift
//  TestGraphs
//
//  Created by Yevhen Herasymenko on 4/15/16.
//  Copyright © 2016 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        circleLayerSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        circleLayerSetup()
    }
    
    
    func circleLayerSetup() {
        let arcPath = UIBezierPath(arcCenter:CGPointMake(100,100), radius:40, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = arcPath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.blueColor().CGColor
        circleLayer.lineWidth = 5.0;
        
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.7
        
        layer.addSublayer(circleLayer)
        
        let arcPath2 = UIBezierPath(arcCenter:CGPointMake(100,100), radius:40, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = arcPath2.CGPath
        circleLayer2.fillColor = UIColor.clearColor().CGColor
        circleLayer2.strokeColor = UIColor.redColor().CGColor
        circleLayer2.lineWidth = 5.0;
        
        circleLayer2.strokeStart = 0
        circleLayer2.strokeEnd = 0.2
        
        layer.addSublayer(circleLayer2)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.2
        animation.toValue = 0.6
        animation.duration = 10 // duration is 1 sec
        // 3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        // 4
        
        circleLayer2.strokeEnd = 0.6
        circleLayer2.addAnimation(animation, forKey: animation.keyPath)
    }

}
