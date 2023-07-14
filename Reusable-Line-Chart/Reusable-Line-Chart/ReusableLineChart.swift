//
//  ReusableLineChart.swift
//  GSS
//
//  Created by User-P2 on 7/13/23.
//  Copyright © 2023 Gallup. All rights reserved.
//

import UIKit
import DGCharts

final class ReusableLineChart: UIView {
    
    // MARK: - Line Patterns
    
    enum LinePattern {
        case none, single, double, triple, tiny
        
        var value: [CGFloat] {
            switch self {
                case .none: return [0]
                case .single: return [10]
                case .double: return [10, 3, 10, 10]
                case .triple: return [10, 3, 10, 3, 10, 10]
                case .tiny: return [5]
            }
        }
    }
    
    // MARK: - Properties
    
    private var chartColor: UIColor = .systemBlue
    private var circleRadius: CGFloat = 10.0
    private var isDataSent: Bool = false
    private var isZoomScaleEnabled: Bool = false
    private var isCircleValuesEnabled: Bool = false
    private var isLeftAxisEnabled: Bool = false
    private var isRightAxisEnabled: Bool = false
    private var isXAxisEnabled: Bool = false
    private var isAllAxisEnabled: Bool = false
    private var isFillColorEnabled: Bool = false
    private var isLegendEnable: Bool = false
    private var fillColor: UIColor = .label
    private var linePattern: LinePattern = .none
    
    private lazy var lineChartDataSet = LineChartDataSet()
    
    private lazy var lineChartView = LineChartView()
    
    /// You will need to adhere to the protocol in this class. Additionally, you can include the line 'chartView.highlightValue(nil)' in any method to disable the marking interaction on the chart.
    @objc
    var delegate: ChartViewDelegate? {
        didSet {
            buildChart()
        }
    }
    
    // TODO: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildChart()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func buildChart() {
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.delegate = delegate
        
        lineChartView.leftAxis.enabled = isAllAxisEnabled || isLeftAxisEnabled
        lineChartView.rightAxis.enabled = isAllAxisEnabled || isRightAxisEnabled
        lineChartView.xAxis.enabled = isAllAxisEnabled || isXAxisEnabled
        lineChartView.setScaleEnabled(isZoomScaleEnabled)
        lineChartView.legend.enabled = isLegendEnable
        
        lineChartDataSet.drawValuesEnabled = isCircleValuesEnabled
        
        /// Primary Circle's config
        lineChartDataSet.circleColors = [.black]
        lineChartDataSet.circleRadius = circleRadius
        
        lineChartDataSet.circleHoleColor = chartColor
        lineChartDataSet.circleHoleRadius = circleRadius * 0.6
        
        /// Line's config
        lineChartDataSet.colors = [chartColor]
        lineChartDataSet.lineWidth = circleRadius * 0.3
        
        /// Fill's config
        lineChartDataSet.drawFilledEnabled = isFillColorEnabled
        lineChartDataSet.fillColor = fillColor.withAlphaComponent(0.2)
        
        /// Line partten
        lineChartDataSet.lineDashLengths = linePattern.value
                
        lineChartView.data = LineChartData(dataSet: lineChartDataSet)
        
        if let _ = subviews.first {
            lineChartView.removeFromSuperview()
        }
        
        addSubview(lineChartView)
        
        setConstraints()
    }
    
    private func setConstraints(){
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineChartView.topAnchor.constraint(equalTo: topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func appendDataSet(data: [String: Int] = [:],
                       label: String,
                       representativeColor: UIColor) {
        
        if isDataSent { return }
        
        isDataSent = true
        
        chartColor = representativeColor
        
        let chartDataEntry: [ChartDataEntry] = (5...10).map {
            ChartDataEntry(x: Double($0),
                           y: Double(Int.random(in: 1...$0)))
        }
        lineChartDataSet = LineChartDataSet(entries: chartDataEntry, label: label)
        buildChart()
    }
    
    func withCircleRadius(_ radius: CGFloat) {
        circleRadius = radius
        buildChart()
    }
    
    func enableScale() {
        isZoomScaleEnabled = true
        buildChart()
    }
    
    func enableLegend(with form: Legend.Form = .square,
                      font: UIFont.TextStyle = .body,
                      formSize: CGFloat = 10,
                      direction: Legend.Direction = .leftToRight,
                      orientation: Legend.Orientation = .horizontal) {
        isLegendEnable = true
        lineChartView.legend.form = form
        lineChartView.legend.font = .preferredFont(forTextStyle: font, compatibleWith: .current)
        lineChartView.legend.formSize = formSize
        lineChartView.legend.direction = direction
        lineChartView.legend.orientation = orientation
        buildChart()
    }
    
    func enableCircleValues() {
        isCircleValuesEnabled = true
        buildChart()
    }
    
    func enableLeftAxis() {
        isLeftAxisEnabled = true
        buildChart()
    }
    
    func enableRightAxis() {
        isRightAxisEnabled = true
        buildChart()
    }
    
    func enableXAxis() {
        isXAxisEnabled = true
        buildChart()
    }
    
    func enableAllAxis() {
        isAllAxisEnabled = true
        buildChart()
    }
    
    func setLinePattern(with: LinePattern) {
        linePattern = with
        buildChart()
    }
}
