//
//  APIClient.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case parsingError
}

protocol APIClient {
    func getAvailableCurrencies(completion: @escaping (Result<[Currency], APIError>) -> Void)
    func getExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, APIError>) -> Void)
}

class ExchangeRatesAPIClient: APIClient {
    private let apiKey = "YOUR_KEY" // Replace with your API key
    
    func getAvailableCurrencies(completion: @escaping (Result<[Currency], APIError>) -> Void) {
        guard let url = URL(string: "https://data.fixer.io/api/symbols?access_key=\(apiKey)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let success = json["success"] as? Bool, success == true,
                  let symbols = json["symbols"] as? [String: String] else {
                      completion(.failure(.invalidResponse))
                      return
                  }
            
            let currencies = symbols.map { Currency(code: $0.key, name: $0.value, rate: 0.0) }
            completion(.success(currencies))
        }.resume()
    }
    
    func getExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, APIError>) -> Void) {
        guard let url = URL(string: "https://data.fixer.io/api/latest?access_key=\(apiKey)&base=\(fromCurrency)&symbols=\(toCurrency)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let rates = json["rates"] as? [String: Double],
                  let rate = rates[toCurrency] else {
                      completion(.failure(.invalidResponse))
                      return
                  }
            
            completion(.success(rate))
        }.resume()
    }
}
