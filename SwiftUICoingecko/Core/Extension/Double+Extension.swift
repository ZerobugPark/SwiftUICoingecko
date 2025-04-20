//
//  Double+Extension.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/20/25.
//

import Foundation

extension Double {
    
    func formatToTwoDecimalPlaces() -> String {
        return String(format: "%.2f", self)
    }
}

