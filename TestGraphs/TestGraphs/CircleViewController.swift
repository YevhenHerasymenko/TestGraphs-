//
//  CircleViewController.swift
//  TestGraphs
//
//  Created by Yevhen Herasymenko on 4/15/16.
//  Copyright © 2016 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {

    @IBOutlet var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func animation(sender: AnyObject) {
        circleView.loadedState = 0.9
    }
    
    @IBAction func animationMinus(sender: AnyObject) {
        circleView.loadedState = 0.1
    }
}
