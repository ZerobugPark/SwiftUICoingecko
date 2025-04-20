//
//  BookmarkView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import SwiftUI

struct BookmarkView: View {
    
    @StateObject var viewModel = BookmarkViewModel()
    
    private var columns: [GridItem] = Array(repeating: .init(.flexible(),spacing: 10), count: 2)
    

    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.output.coinDetail, id: \.id) { item in
                        NavigationLink  {
                            DetailView(id: item.id, isLiked: true)
                        } label: {
                            listView(item)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                    }
                }.padding(.horizontal, 10)
            }
            .navigationTitle("Favorite Coin")
        }.onAppear {
            print(UserDefaultManager.coinId)
        }
        
    }
    
    
    private func listView(_ coin: CoinGeckoMarketAPI) -> some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                CoinInfoBasicView(imageURL: coin.image, title: coin.name, subTitie: coin.symbol, searchText: "", trailing: EmptyView())
                
                Spacer()
                Text("₩" + coin.currentPrice.formatted())
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                let color: Color = coin.priceChangePercent > 0 ? .red : .blue
                HStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(color).opacity(0.3)
                            .frame(width: 100, height: 30)
                            .cornerRadius(5)
                        
                        Text(coin.priceChangePercent.formatToTwoDecimalPlaces() + "%")
                            .foregroundStyle(color)
                  
                    }
                }
                
                
            }.padding(12)

        }
        
        
    }
}

#Preview {
    BookmarkView()
}
