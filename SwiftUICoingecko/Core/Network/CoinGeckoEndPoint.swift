//
//  CoinGeckoEndPoint.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import UIKit

enum CoinGeckoEndPoint {
    

    case coingeckoTrending
    case coingeckoMarket
    case coingeckoSearch
    
    var baseURL: String {
        switch self {
        case .coingeckoTrending, .coingeckoMarket, .coingeckoSearch:
            APIURLs.coingeckoBaseURL
        
        }
    }
    
    
    var path: String {
        switch self {
        case .coingeckoTrending:
            return baseURL + "search/trending"
        case .coingeckoMarket:
            return baseURL + "coins/markets"
        case .coingeckoSearch:
            return baseURL + "search"
        }
        
    }

    
}
