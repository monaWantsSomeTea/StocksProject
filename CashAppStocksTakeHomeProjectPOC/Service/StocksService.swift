//
//  Service.swift
//  CashAppStocksTakeHomeProjectPOC
//
//  Created by Mona Zheng on 9/27/23.
//

import Foundation

protocol StocksProvider {
    static func fetchStocks() async throws -> [Stock]
}

struct StocksService: StocksProvider {
    enum StocksServiceError: Error, Equatable {
        case invalidURL
        case invalidResponse
        case failedToDecode
    }
    
    static func fetchStocks() async throws -> [Stock] {
        guard let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json")
        else {
            throw StocksServiceError.invalidURL
        }
        
        guard let urlForMalformedData = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json")
        else {
            throw StocksServiceError.invalidURL
        }
        
        guard let urlForEmptyList = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_empty.json")
        else {
            throw StocksServiceError.invalidURL
        }
        
        
        
        let session = URLSession(configuration: .ephemeral)
        let (data, response) = try await session.data(from: urlForEmptyList)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            throw StocksServiceError.invalidResponse
        }
        
        do {
            let portfolio = try JSONDecoder().decode(Portfolio.self, from: data)
            return portfolio.stocks
        } catch {
            throw StocksServiceError.failedToDecode
        }
    }
}
