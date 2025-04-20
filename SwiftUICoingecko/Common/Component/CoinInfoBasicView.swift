//
//  CoinInfoBasicView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//


import SwiftUI


struct CoinInfoBasicView<Trailing: View>: View {
    
    var imageURL: String
    var title: String
    var subTitie: String
    var searchText: String
    let trailing: Trailing
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            CoinImageView(url: imageURL)
            VStack(alignment: .leading, spacing: 2) {
                highlightedText(title, searchText: searchText)
                    .lineLimit(1)
                
                Text(subTitie)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            trailing
        }
    }
    
    // 텍스트 하이라이트 함수
    private func highlightedText(_ text: String, searchText: String) -> Text {
        let range = (text as NSString).range(of: searchText, options: .caseInsensitive)
        
        if range.location != NSNotFound {
            let startIndex = text.index(text.startIndex, offsetBy: range.location)
            let endIndex = text.index(startIndex, offsetBy: searchText.count)
            
            return Text(text.prefix(upTo: startIndex)) +
            Text(text[startIndex..<endIndex])
                .foregroundColor(.purple) + // 하이라이트 색상
            Text(text.suffix(from: endIndex))
        } else {
            return Text(text).font(.system(size: 16))
        }
    }
}
