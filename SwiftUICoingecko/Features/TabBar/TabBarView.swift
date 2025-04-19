//
//  TabBarView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        
        
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            BookmarkView()
                .tabItem {
                    Image(systemName: "bookmark")
                }
        
        }
    }
}

#Preview {
    TabBarView()
}
