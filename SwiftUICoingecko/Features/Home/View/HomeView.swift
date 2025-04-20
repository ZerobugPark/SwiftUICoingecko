//
//  HomeView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State private var showFavorites: Bool = true
    
    private var rows: [GridItem] = Array(repeating: .init(.flexible(),spacing: 10), count: 3)
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    firstSection(viewModel.output.liked)
                    
                    Text("Top 15 Coin")
                        .bold()
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    coinsGridSection
                }
                
             
            }
            .navigationTitle("Crypto Coin")
        }
    }
      
}






#Preview {
    HomeView()
}

extension HomeView {
    
    // MARK: Fisrt Section
    @ViewBuilder
    private func firstSection(_ coin: [CoinGeckoMarketAPI]) -> some View {
        if !coin.isEmpty {
            Text("My Favorite")
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach (coin, id: \.id) { item in
                        listView(item)
                    }
                    
                }
                .padding(.horizontal, 16)
                
            }
            .frame(height: 150)
            
            
        } else {
            EmptyView()
        }
        
    }
    
    private func listView(_ coin: CoinGeckoMarketAPI) -> some View {
        
        
        ZStack {
            Rectangle()
                .fill(Color(.systemGray5))
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let color: Color = coin.priceChangePercent > 0 ? .red : .blue
                
                Text(coin.priceChangePercent.formatToTwoDecimalPlaces() + "%")
                    .foregroundStyle(color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }.padding(12)
            
        }.frame(width: 200, height: 130)
    }
    
    
    
    
    // MARK: second Section
    
    private var coinsGridSection: some View {
        ScrollView(.horizontal) {
            let enumerated = Array(viewModel.output.coins.enumerated())
            LazyHGrid(rows: rows) {
                coinsList(enumerated)
            }
        }
    }
    
    private func coinsList(_ items: [(offset: Int, element: TrendingCoinDetails)]) -> some View {
        ForEach(items, id: \.offset) { index, item in
            coinCell(index: index, item: item)
        }
    }
    
    // 개별 코인 셀을 별도 함수로 분리
    private func coinCell(index: Int, item: TrendingCoinDetails) -> some View {
        NavigationLink {
            // DetailView(id: item.id, isLiked: item.isLiked)
            EmptyView() // 임시로 빈 뷰 사용
        } label: {
            HStack {
                Text("\(index + 1)")
                CoinInfoBasicView(
                    imageURL: item.thumb,
                    title: item.name,
                    subTitie: item.symbol,
                    searchText: viewModel.searchText,
                    trailing: tralingView(item.data)
                )
                .contentShape(Rectangle())
            }.padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
    private func tralingView(_ item: TrendingCoinData) -> some View {
            
        VStack(alignment: .trailing, spacing: 12) {
            Text(item.marketCap).font(.system(size: 14))
            
            let color: Color = item.krwPrice ?? 0 > 0 ? .red : .blue
            Text(item.krwPrice?.formatToTwoDecimalPlaces() ?? "0")
                .font(.system(size: 12))
                .foregroundStyle(color)
        }
        
    }
    
    
}

// 코인 데이터 모델
struct Coin: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: String
    let change: String
    let isPositive: Bool
    let icon: String
}

// NFT 데이터 모델
struct NFT: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let icon: String
}

// 코인 카드 뷰 (My Favorite에서 사용)
struct CoinCardView: View {
    let coin: Coin
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: coin.icon)
                    .font(.title2)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading) {
                    Text(coin.name)
                        .font(.callout)
                        .fontWeight(.semibold)
                    Text(coin.symbol)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(coin.price)
                .font(.callout)
                .fontWeight(.semibold)
            
            Text(coin.change)
                .font(.caption)
                .foregroundColor(coin.isPositive ? .green : .red)
        }
        .padding()
        .frame(height: 120)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}


// 코인 랭킹 뷰 (Top 15 Coin에서 사용)
struct CoinRankView: View {
    let rank: Int
    let coin: Coin
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 24)
            
            Image(systemName: coin.icon)
                .font(.title3)
                .foregroundColor(coin.name == "Solana" ? .blue : (coin.name == "Magic Square" ? .purple : .green))
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(coin.symbol)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(coin.price)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(coin.change)
                    .font(.caption)
                    .foregroundColor(coin.isPositive ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

// NFT 랭킹 뷰 (Top 7 NFT에서 사용)
struct NFTRankView: View {
    let rank: Int
    let nft: NFT
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 24)
            
            Image(systemName: nft.icon)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 30, height: 30)
            
            Text(nft.name)
                .font(.callout)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(nft.price)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}
