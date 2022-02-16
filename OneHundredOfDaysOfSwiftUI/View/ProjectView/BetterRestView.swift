//
//  BetterRestView.swift
//  OneHundredOfDaysOfSwiftUI
//
//  Created by Kohei Hayashi on 2022/01/11.
//

import CoreML
import SwiftUI

struct BetterRestView: View {
    @State private var wakeUp = Self.defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    private static var defaultWakeUpTime: Date {
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents) ?? Date.now
    }

    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 5) {
                Text("When do you want to wake up?")
                    .font(.headline)

                DatePicker("Please enter a time",
                           selection: $wakeUp,
                           displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("Desired amount of sleep")
                    .font(.headline)

                Stepper("\(sleepAmount.formatted()) hours",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("Daily coffee intake")
                    .font(.headline)

                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups",
                        value: $coffeeAmount,
                        in: 1...20)

            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
        .navigationTitle(Project.betterRest.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Calculate", action: calculateBedtime)
        }
    }
}

fileprivate extension BetterRestView {
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try BetterRest(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute),
                                                  estimatedSleep: sleepAmount,
                                                  coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct BetterRestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BetterRestView()
        }
    }
}
