//
//  MockNetworkManager.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation

final class MockNetworkManager: NetworkService {
    
    
    
    func callRequest<T: Decodable>(api: CoinGeckpRequest, type: T.Type) async throws -> T {
      
        //let mockData: T
        
        switch api {
        case .coingeckoTrending:
            return mockTrendingAPI as! T
        case .coingeckoMarket:
            return mockTrendingAPI as! T
        case .coingeckoSearch:
            return mockTrendingAPI as! T
        }

        
    }
}


let mockTrendingAPI = CoinGeckoTrendingAPI(
    coins: [
        TrendingCoinItem(item: TrendingCoinDetails(
            id: "bitcoin",
            name: "Bitcoin",
            symbol: "BTC",
            thumb: "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png",
            data: TrendingCoinData(pricePercent: ["krw": 2.45])
        )),
        TrendingCoinItem(item: TrendingCoinDetails(
            id: "ethereum",
            name: "Ethereum",
            symbol: "ETH",
            thumb: "https://assets.coingecko.com/coins/images/279/thumb/ethereum.png",
            data: TrendingCoinData(pricePercent: ["krw": -1.13])
        ))
    ],
    nfts: [
        Nfts(
            name: "Bored Ape Yacht Club",
            symbol: "BAYC",
            thumb: "https://assets.coingecko.com/nfts/images/1234/thumb/bayc.png",
            pricePercent: 3.78
        ),
        Nfts(
            name: "CryptoPunks",
            symbol: "PUNK",
            thumb: "https://assets.coingecko.com/nfts/images/5678/thumb/punk.png",
            pricePercent: -2.45
        )
    ]
)



