//
//  CoinImageView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import SwiftUI

struct CoinImageView: View {
    
    let url: String
    var body: some View {
        // URL 기반으로 이미지 로드 (Kingfisher)
        
        let url = URL(string: url)!
        AsyncImage(url: url) { data in
            switch data {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 30, height: 30)
            case .failure(_):
                Image(systemName: "star")
                    .frame(width: 30, height: 30) // 실패한 이미지에 대해서도 사이즈를 정해줘야 한다.
            @unknown default:
                Image(systemName: "star")
                    .frame(width: 30, height: 30)
            }
        }
        
        
    }
    
}
