//
//  ContentView.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ConverterView(viewModel: ConverterViewModel(apiClient: ExchangeRatesAPIClient()))
            }
    }

