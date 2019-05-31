//
//  CryptoTableViewController.swift
//  CryptoTracker
//
//  Created by Matheus on 29/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        CoinData.shared.delegate = self
        CoinData.shared.getPrices()
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coinDetailViewController = CoinDetailViewController()
        coinDetailViewController.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinDetailViewController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoinData.shared.coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let coin = CoinData.shared.coins[indexPath.row]
        cell.textLabel?.text = coin.symbol + " - \(coin.priceAsString())"
        cell.imageView?.image = coin.image
        return cell
    }
}

extension CryptoTableViewController: CoinDataDelegate {
    func newPrices() {
        self.tableView.reloadData()
    }
}
