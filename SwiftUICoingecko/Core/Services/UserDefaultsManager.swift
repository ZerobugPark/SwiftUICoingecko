//
//  UserDefaultsManager.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import Foundation

@propertyWrapper struct CoinUserDefaultManager<T> {
    
    let key: String
    let empty: T
    
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum UserDefaultManager {
    enum Key: String {
        case coinId
    }
    
    @CoinUserDefaultManager(key: Key.coinId.rawValue, empty: ["":false])
    static var coinId
    
    static func updateCoin(id: String, isLiked: Bool) {
        // 현재 저장된 값 가져오기
        var current = coinId
        
        if isLiked {

            // 이미 10개면 하나 제거
            if current.filter({ $0.value }).count >= 10 {
                if let firstKey = current.filter({ $0.value }).keys.first {
                    current[firstKey] = nil
                }
            }
            current[id] = true
       
        } else {
            current.removeValue(forKey: id)
        }
        
        coinId = current // 딕셔너리 전체를 다시 저장
    }
    
    static func isLiked(id: String) -> Bool {
        return coinId[id] == true
    }
    
    
    
}
