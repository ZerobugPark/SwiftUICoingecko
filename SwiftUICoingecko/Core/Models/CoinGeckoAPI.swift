//
//  CoinGeckoAPI.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation

struct CoinGeckoTrendingAPI: Decodable {
    let coins: [TrendingCoinItem]
    let nfts: [Nfts]
}

struct TrendingCoinItem: Decodable {
    let item: TrendingCoinDetails
}

struct TrendingCoinDetails: Decodable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String
    let data: TrendingCoinData
    
}

struct TrendingCoinData: Decodable {
    
    var pricePercent: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case pricePercent = "price_change_percentage_24h"
    }
    
    var krwPrice: Double? {
        pricePercent["krw"]
    }
    
}



struct Nfts: Decodable {
    let name: String
    let symbol: String
    let thumb: String
    let pricePercent: Double
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case thumb
        case pricePercent = "floor_price_24h_percentage_change"

    }
    

}


struct CoinGeckoMarketAPI: Decodable {
    
    let id: String
    let symbol: String
    let name: String
    let image: String

    let currentPrice: Double
    let priceChangePercent: Double
    
    let marketCap: Double  //시가총액
    let high24h: Double // 24시간 고가
    let low24h: Double // 24시간 초저
   
    let totalVolume: Double  // 총거래량
    let fullyDilutedValuation: Double // 완전희석가치
    let ath: Double // 역대 최고가
    let athDate: String // 최고가 날자
    let atl: Double // 역대 최저가
    let atlDate: String // 최저가 날짜
    let lastUpdated: String
    let sparklineIn7d: [String: [Double]]

    
    enum CodingKeys: String, CodingKey {
        
        case id
        case symbol
        case name
        case image
        
        case currentPrice = "current_price"
        case priceChangePercent = "price_change_percentage_24h"
        case marketCap = "market_cap"
        
        case high24h = "high_24h"
        case low24h = "low_24h"
        
        case totalVolume = "total_volume"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case ath
        case athDate = "ath_date"
        case atl
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7d = "sparkline_in_7d"
    
    }
    
}


struct CoinGeckoSearchAPI: Decodable {
    let coins: [SearchCoin]
}

struct SearchCoin: Decodable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String
    let rank: Int
    var isLiked: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case thumb
        case rank = "market_cap_rank"
    }
    
    
    init(from decoder: any Decoder) throws {
        // 서버에서 받은 데이터를 한번 더 확인
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "nil"
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "nil"
        symbol = try container.decode(String.self, forKey: .symbol)
        thumb = try container.decode(String.self, forKey: .thumb)
        rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? -1
        
        let status = UserDefaultManager.coinId
        isLiked = status[id] ?? false
    }
    
}

