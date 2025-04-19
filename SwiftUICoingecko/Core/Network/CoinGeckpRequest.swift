//
//  CoinGeckpRequest.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import UIKit

enum CoinGeckpRequest {
    

    case coingeckoTrending
    case coingeckoMarket(id: String)
    case coingeckoSearch(query: String)
    

    var endpoint: CoinGeckoEndPoint {
        switch self {
        case .coingeckoTrending:
            return .coingeckoTrending
        case .coingeckoMarket:
            return .coingeckoMarket
        case .coingeckoSearch:
            return .coingeckoSearch
      
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .coingeckoTrending:
            return nil
        case .coingeckoMarket(let id):
            let parameters = ["vs_currency": "krw", "ids": id, "sparkline": "true"]
            return parameters
        case .coingeckoSearch(let query):
            let parameters = ["query": query]
            return parameters
        }
    }
    
    func asURLRequest() -> URLRequest? {
        if let parameters = parameters, !parameters.isEmpty {
            var components = URLComponents(string: endpoint.path)!
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            guard let url = components.url else { return nil }
            return makeRequest(with: url)
        } else {
            guard let url = URL(string: endpoint.path) else { return nil }
            return makeRequest(with: url)
        }
    }
    
    private func makeRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        request.httpMethod = "GET"
      
      
        return request
    }
}


//
//var method: HTTPMethod {
//    return .get
//}
//
//var header: HTTPHeaders? {
//    switch self {
//    case .coingeckoTrending:
//        return nil
//    case .coingeckoMarket(let id):
//        return nil
//    case .coingeckoSearch(let query):
//        return nil
//    }
//}
//
//
//var parameter: Parameters? {
//    switch self {
//    case .coingeckoTrending:
//        return nil
//    case .coingeckoMarket(let id):
//        let parameters = ["vs_currency": "krw", "ids": id, "sparkline": "true"]
//        return parameters
//    case .coingeckoSearch(let query):
//        let parameters = ["query": query]
//        return parameters
//    }
//}
