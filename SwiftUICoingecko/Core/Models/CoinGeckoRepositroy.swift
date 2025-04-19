//
//  CoinGeckoRepositroy.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation


protocol NetworkService {
    func callRequest<T: Decodable>(api: CoinGeckpRequest, type: T.Type) async throws -> T
}
