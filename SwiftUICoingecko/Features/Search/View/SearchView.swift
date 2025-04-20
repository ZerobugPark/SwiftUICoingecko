//
//  SearchView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                searchListView()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchText)
        }
        .onSubmit(of: .search) {
            viewModel.input.serachSubmitted.send()
        }
        
    }
    
    private func searchListView() -> some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach($viewModel.output.coins, id: \.id) { $item in
                    NavigationLink {
                        DetailView(id: item.id, isLiked: item.isLiked)
                    } label: {
                        CoinInfoBasicView(imageURL: item.thumb, title: item.name, subTitie: item.symbol, searchText: viewModel.searchText, trailing: BookmarkButtonView(id: item.id, item.isLiked))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
          
         
            }.padding(.horizontal, 24)
        }
    }
    
    private func BookmarkButtonView(id: String,_ isLiked: Bool) -> some View {
        
        Button  {
            viewModel.input.bookmarkToggled.send(id)
        } label: {
            Image(systemName: isLiked ? "star.fill" : "star" )
        }
    }
    
}


#Preview {
    SearchView()
}
