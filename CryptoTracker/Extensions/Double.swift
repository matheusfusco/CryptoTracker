//
//  Double.swift
//  CryptoTracker
//
//  Created by Matheus on 31/05/19.
//  Copyright © 2019 Matheus. All rights reserved.
//

import Foundation

extension Double {
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(floatLiteral: self)) ?? "$ 0.00"
    }
}
