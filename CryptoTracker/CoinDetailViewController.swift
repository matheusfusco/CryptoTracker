//
//  CoinDetailViewController.swift
//  CryptoTracker
//
//  Created by Matheus on 30/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import UIKit
import SwiftChart

class CoinDetailViewController: UIViewController {
    var chart = Chart()
    var priceOnDayLabel = UILabel()
    var coinImageView = UIImageView()
    var currentCoinPriceLabel = UILabel()
    var youOwnLabel = UILabel()
    var worthLabel = UILabel()
    var coin: Coin? {
        didSet {
            updateValues()
        }
    }
    var priceOnDayLabelCenterXConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = coin?.symbol
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        setupChart()
        coin?.getHistoricalData()
    }
    
    private func setupChart() {
        CoinData.shared.delegate = self
        guard let coin = self.coin else { return }
        
        self.view.addSubview(priceOnDayLabel)
        priceOnDayLabel.anchor(centerX: (anchor: self.view.leftAnchor, padding: 0),
                               top: (anchor: self.view.topAnchor, padding: 8),
                               height: 20)
        priceOnDayLabelCenterXConstraint = priceOnDayLabel.findConstraint(layoutAttribute: NSLayoutConstraint.Attribute.centerX)
        priceOnDayLabel.font = UIFont.systemFont(ofSize: 12)
        priceOnDayLabel.numberOfLines = 0
        priceOnDayLabel.adjustsFontSizeToFitWidth = true
        priceOnDayLabel.isHidden = true
        
        self.view.addSubview(chart)
        chart.anchor(top: (anchor: priceOnDayLabel.bottomAnchor, padding: 8),
                     left: (anchor: self.view.leftAnchor, padding: 16),
                     right: (anchor: self.view.rightAnchor, padding: 16),
                     height: 300)
        chart.delegate = self
        chart.hideHighlightLineOnTouchEnd = true
        chart.yLabelsFormatter = { $1.formatCurrency() }
        chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
        
        self.view.addSubview(coinImageView)
        coinImageView.anchor(centerX: (anchor: self.view.centerXAnchor, padding: 8),
                             top: (anchor: chart.bottomAnchor, padding: 16),
                             width: 120,
                             height: 120)
        coinImageView.image = coin.image
        
        self.view.addSubview(currentCoinPriceLabel)
        currentCoinPriceLabel.anchor(top: (anchor: coinImageView.bottomAnchor, padding: 16),
                                     left: (anchor: self.view.leftAnchor, padding: 16),
                                     right: (anchor: self.view.rightAnchor, padding: 16),
                                     height: 25)
        currentCoinPriceLabel.textAlignment = .center
        currentCoinPriceLabel.font = UIFont.systemFont(ofSize: 25)
        
        self.view.addSubview(youOwnLabel)
        youOwnLabel.anchor(top: (anchor: currentCoinPriceLabel.bottomAnchor, padding: 8),
                                     left: (anchor: self.view.leftAnchor, padding: 16),
                                     right: (anchor: self.view.rightAnchor, padding: 16),
                                     height: 20)
        youOwnLabel.textAlignment = .center
        youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.view.addSubview(worthLabel)
        worthLabel.anchor(top: (anchor: youOwnLabel.bottomAnchor, padding: 8),
                           left: (anchor: self.view.leftAnchor, padding: 16),
                           right: (anchor: self.view.rightAnchor, padding: 16),
                           height: 20)
        worthLabel.textAlignment = .center
        worthLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    @objc func editButtonClicked() {
        guard let coin = self.coin else { return }
        let alert = UIAlertController(title: "How much \(coin.symbol) do you own?", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "0.0"
            textField.keyboardType = .decimalPad
            if self.coin?.amountOwned != 0 {
                textField.text = "\(coin.amountOwned)"
            }
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            guard let text = alert.textFields?[0].text, let amount = Double(text) else { return }
            self.coin?.amountOwned = amount
            self.updateValues()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateValues() {
        guard let coin = self.coin else { return }
        currentCoinPriceLabel.text = coin.price.formatCurrency()
        youOwnLabel.text = "You own \(coin.amountOwned) \(coin.symbol)"
        worthLabel.text = "That worths \((coin.price * coin.amountOwned).formatCurrency())"
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
    
    func newPrices() {
        updateValues()
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
