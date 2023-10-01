//
//  Stock.swift
//  CashAppStocksTakeHomeProjectPOC
//
//  Created by Mona Zheng on 9/27/23.
//

import Foundation

public struct Portfolio: Decodable {
    let stocks: [Stock]
}

public struct Stock: Decodable, Equatable {
    let ticker: String
    let name: String
    let currency: String
    let currentPrice: String
    let quantity: Int?
    let currentPriceTimestamp: Int
    
    enum StockKeys: String, Swift.CodingKey {
        case ticker = "ticker"
        case name = "name"
        case currency = "currency"
        case currentPriceCents = "current_price_cents"
        case quantity = "quatitiy"
        case currentPriceTimestamp = "current_price_timestamp"
    }
    
    private enum StockDecodingError: Error {
        case unableToConvertCentsToCurrency
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StockKeys.self)
        
        self.ticker = try container.decode(String.self, forKey: .ticker)
        self.name = try container.decode(String.self, forKey: .name)
        self.currency = try container.decode(String.self, forKey: .currency)
        
        let currentPriceCents = try container.decode(Int.self, forKey: .currentPriceCents)
        let currentPrice = Double(currentPriceCents)/100
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .currency
        
        guard let currentPriceFormatted = numberFormater.string(for: NSNumber(value: currentPrice))
        else {
            throw StockDecodingError.unableToConvertCentsToCurrency
        }
        
        self.currentPrice = currentPriceFormatted
        
        self.quantity = try? container.decode(Int.self, forKey: .quantity)
        self.currentPriceTimestamp = try container.decode(Int.self, forKey: .currentPriceTimestamp)
    }
}

