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
    var coin: Coin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        CoinData.shared.delegate = self
        view.backgroundColor = .white
        
        chart.frame = CGRect(x: 16, y: 0, width: view.frame.size.width - 32, height: chartHeight)
        chart.yLabelsFormatter = { CoinData.shared.doubleToCurrencyString($1) }
        chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
        self.view.addSubview(chart)
        coin?.getHistoricalData()
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
