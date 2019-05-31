//
//  CoinData.swift
//  CryptoTracker
//
//  Created by Matheus on 29/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol CoinDataDelegate: class {
    @objc optional func newPrices()
    @objc optional func newHistory()
}

class CoinData {
    static let shared = CoinData()
    var coins = [Coin]()
    weak var delegate: CoinDataDelegate?
    
    private init() {
        let symbols = ["BTC", "ETH", "LTC"]
        for symbol in symbols {
            let coin = Coin(symbol: symbol)
            coins.append(coin)
        }
    }
    
    func getPrices() {
        var listOfSymbols = ""
        for coin in coins {
            listOfSymbols += coin.symbol
            if coin.symbol != coins.last?.symbol {
                listOfSymbols += ","
            }
        }
        
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD").responseJSON { (response) in
            if let json = response.result.value as? [String: Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as? [String: Double] {
                        if let coinPrice = coinJSON["USD"] {
                            coin.price = coinPrice
                        }
                    }
                }
                self.delegate?.newPrices?()
            }
        }
    }
}

class Coin  {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amountOwned = 0.0
    var historicalData = [Double]()
    
    init(symbol: String) {
        self.symbol = symbol
        if let image = UIImage(named: symbol) {
            self.image = image
        }
    }
    
    func priceAsString() -> String {
        if price == 0 {
            return "Loading..."
        }
        return price.formatCurrency()
    }
    
    func getHistoricalData() {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON { (response) in
            if let json = response.result.value as? [String: Any] {
                if let pricesJSON = json["Data"] as? [[String: Double]] {
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrice = priceJSON["close"] {
                            self.historicalData.append(closePrice)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?()
                }
            }
        }
    }
}
