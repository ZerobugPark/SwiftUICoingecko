//
//  DetailViewModel.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI
import Combine


final class DetailViewModel: ViewModelType {
    
    var input = Input()
    @Published var output = Output()
    
    let id: String
    
    var cancellables = Set<AnyCancellable>()
    
    init(id: String) {
        self.id = id
        transform()
    }
    
}

// MARK: Input/Output
extension DetailViewModel {
    struct Input {
        let bookmarkToggled = PassthroughSubject<(String,Bool), Never>()
    }
    
    struct Output {
        var coinDetail: [CoinGeckoMarketAPI] = []
    }
    
    func transform() {
        loadDetailCoinInfo(id: id)
        
        input.bookmarkToggled
            .sink { [weak self] data in
                self?.toggleBookmark(data)
            }
            .store(in: &cancellables)
        
    }
}

extension DetailViewModel {
    
    private func loadDetailCoinInfo(id: String) {
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(
                    api: .coingeckoMarket(id: id),
                    type: [CoinGeckoMarketAPI].self
                )
                
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.output.coinDetail = result
                }
                
                
            } catch let error as APIError {
                print("APIError: \(error.message)")
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
    
    private func toggleBookmark(_ data: (String,Bool)) {
        
        NotificationCenter.default.post(
            name: .didToggleFavorite,
            object: nil,
            userInfo: ["id": data.0, "isFavorite": data.1]
        )
    }
    
    
}
