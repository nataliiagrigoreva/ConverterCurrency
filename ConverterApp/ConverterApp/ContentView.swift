//
//  ContentView.swift
//  ConverterApp
//
//  Created by Nataly on 29.06.2023.
//
import SwiftUI

struct ContentView: View {
    @State private var amount = ""
    @State private var selectedCurrencyFrom = 0
    @State private var selectedCurrencyTo = 0
    @State private var convertedAmount = ""

    let currencies = ["USD", "AUD", "CAD", "PLN", "MXN"]

    var body: some View {
        VStack {
            TextField("Сумма", text: $amount)
                .keyboardType(.decimalPad)
                .padding()

            Picker("Из", selection: $selectedCurrencyFrom) {
                ForEach(0..<currencies.count) {
                    Text(self.currencies[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Picker("В", selection: $selectedCurrencyTo) {
                ForEach(0..<currencies.count) {
                    Text(self.currencies[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Конвертировать") {
                convertAmount()
            }
            .padding()

            Text(convertedAmount)
                .padding()
        }
    }

    func convertAmount() {
        guard let amount = Double(amount) else {
            convertedAmount = "Неверная сумма"
            return
        }

        guard selectedCurrencyFrom != selectedCurrencyTo else {
            convertedAmount = "\(amount)"
            return
        }

        let currencyFrom = currencies[selectedCurrencyFrom]
        let currencyTo = currencies[selectedCurrencyTo]

        let apiKey = "YOUR_API_KEY"
        let urlString = "https://api.exchangeratesapi.io/v1/convert?access_key=\(apiKey)&from=\(currencyFrom)&to=\(currencyTo)&amount=\(amount)"

        guard let url = URL(string: urlString) else {
            convertedAmount = "Ошибка URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                convertedAmount = "Ошибка сети"
                return
            }

            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let success = responseJSON["success"] as? Bool,
               success,
               let result = responseJSON["result"] as? Double {
                convertedAmount = "\(result)"
            } else {
                convertedAmount = "Ошибка конвертации"
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
