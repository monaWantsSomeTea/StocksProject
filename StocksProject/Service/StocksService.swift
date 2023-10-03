//
//  Service.swift
//  StocksProject
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
        guard let url = URL(string: "https://mock-data-stocks.s3.us-west-1.amazonaws.com/portfolio.json")
        else {
            throw StocksServiceError.invalidURL
        }
        
        // TODO: Remove - Used to test states
//        guard let urlForMalformedData = URL(string: "https://mock-data-stocks.s3.us-west-1.amazonaws.com/malformedJSONPortfolio.json")
//        else {
//            throw StocksServiceError.invalidURL
//        }
//
//        guard let urlForEmptyList = URL(string: "https://mock-data-stocks.s3.us-west-1.amazonaws.com/portfolioEmptyStocks.json")
//        else {
//            throw StocksServiceError.invalidURL
//        }
        
        
        
        let session = URLSession(configuration: .ephemeral)
        let (data, response) = try await session.data(from: url)
        
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
