//
//  DetailView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI

struct DetailView: View {
    let id: String
    @State var isLiked: Bool
    @Environment(\.dismiss) private var dismiss // 뒤로 가기용 Environment
    @StateObject var viewModel: DetailViewModel
    
    init(id: String, isLiked: Bool) {
        self.id = id
        self.isLiked = isLiked
        _viewModel = StateObject(wrappedValue: DetailViewModel(id: id))
        
    }
    
    
    var body: some View {
        NavigationStack {
            Group {
                if let coin = viewModel.output.coinDetail.first {
                    VStack(alignment: .leading, spacing: 0) {
                        coinDetailView(coin)
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss() // 뒤로 가기
                    }
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // 즐겨찾기 로직
                        isLiked.toggle()
                        viewModel.input.bookmarkToggled.send((id, isLiked))
                    }) {
                        Image(systemName: isLiked ? "star.fill" : "star")
                            .foregroundColor(.purple)
                    }
                }
            }.navigationBarBackButtonHidden(true)
     
        }
    }
    
    
    private func coinDetailView(_ coin: CoinGeckoMarketAPI) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            titleSection(coin.name, coin.image)
            priceSection(coin.currentPrice, coin.priceChangePercent)
            detailPrice(coin)
            chartView(coin)
            Spacer()
        }.padding(.horizontal, 12)
        
    }
    
    
    private func titleSection(_ title: String, _ image: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            
            CoinImageView(url: image)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
        }
        
    }
    
    @ViewBuilder
    private func priceSection(_ price: Double, _ percent: Double) -> some View {
        Text("₩\(price.formatted())")
            .font(.title)
            .fontWeight(.bold)
        
        HStack(alignment: .center, spacing: 4) {
            let color: Color = percent > 0 ? .red : .blue
            
            Text(percent.formatToTwoDecimalPlaces() + "%").foregroundStyle(color)
            Text("Today").foregroundStyle(.gray)
            Spacer()
        }
    }
    
    private func detailPrice(_ coin: CoinGeckoMarketAPI) -> some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8) {
                
                detailText("고가", second: coin.high24h, color: .red)
                detailText("신고점", second: coin.ath, color: .red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                
                detailText("저가", second: coin.low24h, color: .blue)
                detailText("신저점", second: coin.atl, color: .blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.top, 10)
        
    }
    
    @ViewBuilder
    private func detailText(_ first: String, second: Double, color: Color) -> some View {
        Text(first)
            .foregroundColor(color)
            .font(.system(size: 14))
        
        Text(second.formatted())
            .font(.system(size: 14))
            .foregroundStyle(.gray)
        
    }
    
    private func chartView(_ coin: CoinGeckoMarketAPI) -> some View {
        VStack {
            
            PriceChartView(chartData: coin.sparklineIn7d)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
            
            HStack {
                Spacer()
                Text(convertToDateString(coin.lastUpdated) + " 업데이트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.trailing)
                    .padding(.bottom, 5)
            }
        }
    }
    
    
    
    func convertToDateString(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: isoString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            formatter.dateFormat = "M/d HH:mm:ss"
            return formatter.string(from: date)
        } else {
            return "날짜 변환 실패"
        }
    }
    

}

