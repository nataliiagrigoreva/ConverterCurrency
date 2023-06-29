//
//  ConverterView.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//

// ConverterView.swift

// ConverterView.swift

import Foundation
import SwiftUI

struct ConverterView: View {
    
    @StateObject var viewModel: ConverterViewModel
    @State private var fromCurrency: Currency?
    @State private var toCurrency: Currency?

    var body: some View {
        VStack {
            Text("Currency converter")
                .font(.title)
                .padding(.bottom, 20)
            
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
            
            Picker("From Currency", selection: $fromCurrency) {
                ForEach(viewModel.currencies, id: \.self) { currency in
                    Text(currency.name)
                        .tag(currency)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: fromCurrency) { newValue in
                viewModel.fromCurrency = newValue
                viewModel.updateConvertedAmount()
            }

            Picker("To Currency", selection: $toCurrency) {
                ForEach(viewModel.currencies, id: \.self) { currency in
                    Text(currency.name)
                        .tag(currency)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: toCurrency) { newValue in
                viewModel.toCurrency = newValue
                viewModel.updateConvertedAmount()
            }

            
            Button("Convert") {
                viewModel.convert()
            }
            
            Text("Converted Amount: \(viewModel.convertedAmount)")
                .padding(.top, 20)
        }
        .padding()
    }
}
