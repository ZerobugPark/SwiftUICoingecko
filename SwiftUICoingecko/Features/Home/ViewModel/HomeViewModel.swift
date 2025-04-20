//
//  HomeViewModel.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI
import Combine


final class HomeViewModel: ViewModelType {
    
    
    var input = Input()
    @Published var output = Output()
    @Published var searchText: String = "" // 구조체 내에서는 Pulbish 사용 불가
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        transform()
        loadIsLikedCoinInfo()
        getTrendingData()
    }
    
    
}


extension HomeViewModel {
    
    struct Input {
    
    }
    
    struct Output {
        var liked: [CoinGeckoMarketAPI] = []
        var coins: [TrendingCoinDetails] = []
        var nft: [Nfts] = []
    }
    
    func transform() {
    }
}

// MARK: Action
extension HomeViewModel {
    
    private func getTrendingData() {
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(
                    api: .coingeckoTrending,
                    type: CoinGeckoTrendingAPI.self
                )

                await MainActor.run { [weak self] in
                    self?.output.coins = result.coins.map {TrendingCoinDetails(id: $0.item.id, name: $0.item.name, symbol: $0.item.symbol, thumb: $0.item.thumb, data: $0.item.data) }
                    self?.output.nft = result.nfts
                }
            } catch let error as APIError {
                print("APIError: \(error.message)")
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
    
    
 
    private func loadIsLikedCoinInfo() {
        let isLikedKeys = UserDefaultManager.coinId.keys.sorted()
        let joinedIDs = isLikedKeys.joined(separator: ",")  // 쉼표로 이어붙이기
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(
                    api: .coingeckoMarket(id: joinedIDs),
                    type: [CoinGeckoMarketAPI].self
                )

                await MainActor.run { [weak self] in
                    self?.output.liked = result
                }
            } catch let error as APIError {
                print("APIError: \(error.message)")
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
  
}
