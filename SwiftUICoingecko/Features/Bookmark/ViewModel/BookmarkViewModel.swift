//
//  BookmarkViewModel.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI
import Combine


final class BookmarkViewModel: ViewModelType {
    
    var input = Input()
    @Published var output = Output()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        transform()
    }
    
}

// MARK: Input/Output
extension BookmarkViewModel {
    struct Input {
       
    }
    
    struct Output {
        var coinDetail: [CoinGeckoMarketAPI] = []
    }
    
    func transform() {
        loadIsLikedCoinInfo()
        observeFavoriteToggle()
    }
}

extension BookmarkViewModel {
    
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
                    self?.output.coinDetail = result
                }
            } catch let error as APIError {
                print("APIError: \(error.message)")
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
        

    private func observeFavoriteToggle() {
        NotificationCenter.default.publisher(for: .didToggleFavorite)
            .sink { [weak self] notification in
                guard
                    let userInfo = notification.userInfo,
                    let id = userInfo["id"] as? String,
                    let isFavorite = userInfo["isFavorite"] as? Bool
                    
                else { return }

                guard let self = self else { return }
                UserDefaultManager.updateCoin(id: id, isLiked: isFavorite)
                loadIsLikedCoinInfo()
            }
            .store(in: &cancellables)
    }
    
}
