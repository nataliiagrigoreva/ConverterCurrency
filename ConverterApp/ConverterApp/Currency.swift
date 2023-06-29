//
//  Currency.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

struct Currency: Equatable {
    let code: String
    let name: String
    let rate: Double
    
    init(code: String, name: String, rate: Double) {
        self.code = code
        self.name = name
        self.rate = rate
    }
}

extension Currency: Hashable {}

