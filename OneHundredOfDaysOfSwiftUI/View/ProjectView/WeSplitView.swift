//
//  WeSplitView.swift
//  OneHundredOfDaysOfSwiftUI
//
//  Created by Kohei Hayashi on 2021/12/17.
//

import SwiftUI

struct WeSplitView: View {
    private let tipPercentages = [10, 15, 20, 25, 0]
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20

    @FocusState private var amountIsFocus: Bool

    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson.isNaN ? 0 : amountPerPerson
    }

    var body: some View {
        Form {
            let code = Locale.current.currencyCode ?? "USD"
            Section {
                TextField("Amount",
                          value: $checkAmount,
                          format: .currency(code: code))
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocus)
                Picker("Number of people", selection: $numberOfPeople) {
                    ForEach(2..<100) {
                        Text("\($0) people")
                    }
                }
            }
            Section {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(tipPercentages, id: \.self) {
                        Text($0, format: .percent)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("How much tip do you want to leave?")
            }
            Section {
                Text(totalPerPerson, format: .currency(code: code))
                    .foregroundColor(tipPercentage == 0 ? .red : .primary)
            }
        }
        .navigationTitle(Project.weSplit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    amountIsFocus = false
                }
            }
        }
    }
}

struct WeSplitView_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitView()
    }
}
