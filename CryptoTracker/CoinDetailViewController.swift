//
//  CoinDetailViewController.swift
//  CryptoTracker
//
//  Created by Matheus on 30/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight: CGFloat = 300.0

class CoinDetailViewController: UIViewController {
    var chart = Chart()
    var priceOnDayLabel = UILabel()
    var coin: Coin?
//    var priceOnDayLabelLeadingConstraint: NSLayoutConstraint?
    var priceOnDayLabelCenterXConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        setupChart()
        coin?.getHistoricalData()
    }
    
    private func setupChart() {
        CoinData.shared.delegate = self
        
        self.view.addSubview(priceOnDayLabel)
        priceOnDayLabel.anchor(centerX: (anchor: self.view.leftAnchor, padding: 0),
                               top: (anchor: self.view.topAnchor, padding: 5),
//                               left: (anchor: self.view.leftAnchor, padding: 0),
                               height: 20)
//        priceOnDayLabelLeadingConstraint = priceOnDayLabel.findConstraint(layoutAttribute: NSLayoutConstraint.Attribute.left)
        priceOnDayLabelCenterXConstraint = priceOnDayLabel.findConstraint(layoutAttribute: NSLayoutConstraint.Attribute.centerX)
        priceOnDayLabel.backgroundColor = .yellow
        priceOnDayLabel.numberOfLines = 0
        priceOnDayLabel.adjustsFontSizeToFitWidth = true
        priceOnDayLabel.isHidden = true
        
        self.view.addSubview(chart)
        chart.anchor(top: (anchor: priceOnDayLabel.bottomAnchor, padding: 5),
                     left: (anchor: self.view.leftAnchor, padding: 16),
                     right: (anchor: self.view.rightAnchor, padding: 16),
                     height: chartHeight)
        chart.delegate = self
        chart.hideHighlightLineOnTouchEnd = true
        chart.yLabelsFormatter = { $1.formatCurrency() }
        chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
    }
}

extension CoinDetailViewController: CoinDataDelegate {
    func newHistory() {
        guard let coin = self.coin else { return }
        let series = ChartSeries(coin.historicalData)
        series.area = true
        series.color = ChartColors.greenColor()
        chart.add(series)
    }
}

extension CoinDetailViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil, let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                priceOnDayLabel.isHidden = false
                priceOnDayLabel.text = value.formatCurrency()
                priceOnDayLabel.frame.size.width = priceOnDayLabel.intrinsicContentSize.width
                if let priceOnDayLabelCenterXConstraint = self.priceOnDayLabelCenterXConstraint {
                    priceOnDayLabelCenterXConstraint.constant = left + 16
                }
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        priceOnDayLabel.isHidden = true
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        priceOnDayLabel.isHidden = true
    }
    
    
}
