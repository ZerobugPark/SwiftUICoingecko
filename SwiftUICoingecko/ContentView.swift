//
//  ContentView.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            Task {
                do {
                    let result = try await MockNetworkManager().callRequest(api: .coingeckoTrending, type: CoinGeckoTrendingAPI.self)
                    dump(result)
                } catch let error as APIError {
                    print(error.message)
                } catch {
                    print(error)
                }
            }
         
        }
    }
}

//#Preview {
//    ContentView()
//}
