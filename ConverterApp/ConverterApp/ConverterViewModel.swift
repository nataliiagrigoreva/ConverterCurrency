//
//  ConverterViewModel.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//
// ConverterViewModel.swift

import Foundation

class ConverterViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var fromCurrency: Currency?
    @Published var toCurrency: Currency?
    @Published var convertedAmount: String = ""
    @Published var currencies: [Currency] = []
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        fetchCurrencies()
    }
    
    private func fetchCurrencies() {
        let currencies: [Currency] = [
            Currency(code: "USD", name: "United States Dollar", rate: 1.088198),
            Currency(code: "AUD", name: "Australian Dollar", rate: 1.641127),
            Currency(code: "CAD", name: "Canadian Dollar", rate: 1.441705),
            Currency(code: "PLN", name: "Polish Zloty", rate: 4.444789),
            Currency(code: "MXN", name: "Mexican Peso", rate: 18.617821)
        ]
        
        self.currencies = currencies
    }

    
    func convert() {
        guard let amount = Double(amount) else {
            convertedAmount = "Invalid amount"
            return
        }
        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {
            convertedAmount = "Invalid currencies"
            return
        }
        
        apiClient.getExchangeRate(fromCurrency: fromCurrency.code, toCurrency: toCurrency.code) { result in
            switch result {
            case .success(let rate):
                let converted = amount * rate
                self.convertedAmount = String(format: "%.2f", converted)
            case .failure(let error):
                self.convertedAmount = "Conversion failed: \(error.localizedDescription)"
            }
        }
    }
    
    func updateConvertedAmount() {
        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {
            convertedAmount = ""
            return
        }
        
        apiClient.getExchangeRate(fromCurrency: fromCurrency.code, toCurrency: toCurrency.code) { result in
            switch result {
            case .success(let rate):
                guard let amount = Double(self.amount) else {
                    self.convertedAmount = "Invalid amount"
                    return
                }
                
                let converted = amount * rate
                self.convertedAmount = String(format: "%.2f", converted)
            case .failure(let error):
                self.convertedAmount = "Conversion failed: \(error.localizedDescription)"
            }
        }
    }
}
