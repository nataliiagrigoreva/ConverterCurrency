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
    private let apiKey = "f0c58e87b9c5760607a1481bfdb80dfd" // Replace with your API key
    
    func getAvailableCurrencies(completion: @escaping (Result<[Currency], APIError>) -> Void) {
        let currencies: [Currency] = [
                Currency(code: "USD", name: "United States Dollar", rate: 1.088198),
                Currency(code: "AUD", name: "Australian Dollar", rate: 1.641127),
                Currency(code: "CAD", name: "Canadian Dollar", rate: 1.441705),
                Currency(code: "PLN", name: "Polish Zloty", rate: 4.444789),
                Currency(code: "MXN", name: "Mexican Peso", rate: 18.617821)
            ]
            
            completion(.success(currencies))
        
        guard let url = URL(string: "https://api.exchangeratesapi.io/latest?access_key=\(apiKey)") else {
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
                  let rates = json["rates"] as? [String: Double] else {
                      completion(.failure(.invalidResponse))
                      return
                  }
            
            let currencies = rates.map { Currency(code: $0.key, name: $0.key, rate: $0.value) }
            completion(.success(currencies))
        }.resume()
    }

    func getExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, APIError>) -> Void) {
        guard let url = URL(string: "https://api.exchangeratesapi.io/latest?access_key=\(apiKey)&base=\(fromCurrency)&symbols=\(toCurrency)") else {
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
