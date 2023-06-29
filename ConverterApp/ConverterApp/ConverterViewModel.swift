//
//  ConverterViewModel.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

class ConverterViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var fromCurrency: Currency?
    @Published var toCurrency: Currency?
    @Published var convertedAmount: String = ""
    @Published var currencies: [String: String] = [:]
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        fetchCurrencies()
    }
    
    private func fetchCurrencies() {
        apiClient.getAvailableCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.currencies = currencies.reduce(into: [String: String]()) { dict, currency in
                        dict[currency.code] = currency.name
                    }
                case .failure(let error):
                    print("Failed to fetch currencies: \(error.localizedDescription)")
                }
            }
        }
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
