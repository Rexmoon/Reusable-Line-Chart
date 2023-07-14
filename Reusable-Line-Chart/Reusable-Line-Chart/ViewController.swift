//
//  ViewController.swift
//  Reusable-Chart-Mock
//
//  Created by User-P2 on 7/13/23.
//

import UIKit
import DGCharts

final class ViewController: UIViewController {
    
    @IBOutlet private var lineChartView: ReusableLineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        lineChartView.appendDataSet(label: "Legend 1", representativeColor: .green)
        lineChartView.enableCircleValues()
        lineChartView.delegate = self
    }
}

// MARK: - Reusable ChartView Delegate

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.highlightValue(nil)
        
        let alertController = UIAlertController(title: "Entry Tapped", message: "\(entry)", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}
