//
//  PlotViewController.swift
//  TestGraphs
//
//  Created by Yevhen Herasymenko on 4/15/16.
//  Copyright © 2016 Yevhen Herasymenko. All rights reserved.
//

import UIKit
import Charts

class PlotViewController: UIViewController {

    static let PointsCount = 50
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let limitLine = ChartLimitLine(limit: 5, label: "")
        limitLine.lineWidth = 2
        lineChartView.leftAxis.addLimitLine(limitLine)
        lineChartView.leftAxis.axisMaxValue = 10
        lineChartView.leftAxis.axisMinValue = 0
        
        drawChart()
    }
    
    func drawChart() {
        let xVals = (0...PlotViewController.PointsCount).map {
            return String($0)
        }
        let yVals: [ChartDataEntry] = (0...PlotViewController.PointsCount).map { index in
            let val = Double(arc4random_uniform(9))
            return ChartDataEntry(value: val, xIndex: index)
        }
        
        let set = LineChartDataSet(yVals: yVals, label: "")
        set.colors = [UIColor.clearColor()]
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        
        set.drawCubicEnabled = true
        
        let gradientColors = [UIColor.lightGrayColor().CGColor, UIColor.lightGrayColor().CGColor, UIColor.redColor().CGColor, UIColor.redColor().CGColor]
        let gradient = CGGradientCreateWithColors(nil, gradientColors, [0.49, 0.495, 0.5, 1.0])
        
        set.fillAlpha = 1.0
        set.fill = ChartFill(linearGradient: gradient!, angle: 90)
        set.drawFilledEnabled = true
        set.highlightColor = UIColor.clearColor()
        set.drawSteppedEnabled = false
        
        let dataSets = [set]
        let data = LineChartData(xVals: xVals, dataSets: dataSets)

        lineChartView.descriptionTextColor = UIColor.clearColor()

        lineChartView.leftAxis.axisLineColor = UIColor.clearColor()
        lineChartView.leftAxis.labelTextColor = UIColor.clearColor()
        lineChartView.leftAxis.gridColor = UIColor.clearColor()
        lineChartView.rightAxis.gridColor = UIColor.clearColor()
        lineChartView.xAxis.gridColor = UIColor.clearColor()
        lineChartView.rightAxis.axisLineColor = UIColor.clearColor()
        lineChartView.rightAxis.labelTextColor = UIColor.clearColor()
        lineChartView.xAxis.labelTextColor = UIColor.clearColor()
        lineChartView.xAxis.axisLineColor = UIColor.clearColor()
        
        lineChartView.xAxis.axisLineColor = UIColor.clearColor()
        
        lineChartView.data = data
        
    }

}
