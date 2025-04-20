//
//  SearchViewModel.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI
import Combine


final class SearchViewModel: ViewModelType {
    
    
    var input = Input()
    @Published var output = Output()
    @Published var searchText: String = "" // 구조체 내에서는 Pulbish 사용 불가
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        transform()
    }
    
    
}


extension SearchViewModel {
    
    struct Input {
        let serachSubmitted = PassthroughSubject<Void, Never>()
        let bookmarkToggled = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var coins: [SearchCoin] = []
    }
    
    func transform() {
        input.serachSubmitted
            .sink { [weak self] query in
                guard let self = self else { return }
                searchResult(query: self.searchText)
                
            }.store(in: &cancellables)
        
        input.bookmarkToggled.sink { [weak self] id in
            guard let self = self  else { return }
            self.handleBookmarkToggle(id: id)
        }.store(in: &cancellables)
    }
}

// MARK: Action

extension SearchViewModel {
    
    
    private func searchResult(query: String) {
        Task {
            do {
                let result = try await NetworkManager.shared.callRequest(
                    api: .coingeckoSearch(query: query),
                    type: CoinGeckoSearchAPI.self
                )
                
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.output.coins = result.coins
                }
                
                
            } catch let error as APIError {
                print("APIError: \(error.message)")
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
    
    private func handleBookmarkToggle(id: String) {
        guard let index = output.coins.firstIndex(where: { $0.id == id }) else { return }
        output.coins[index].isLiked.toggle()
        let newState = output.coins[index].isLiked
        UserDefaultManager.updateCoin(id: id, isLiked: newState)
    }
    
}
