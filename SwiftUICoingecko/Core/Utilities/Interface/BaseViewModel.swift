//
//  BaseViewModel.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import Foundation
import Combine


protocol ViewModelType: AnyObject, ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set } //disposeBag
    
    var input: Input { get set }
    var output: Output { get set }
    
    func transform()
}
