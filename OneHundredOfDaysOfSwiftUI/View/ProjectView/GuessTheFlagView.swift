//
//  GuessTheFlagView.swift
//  OneHundredOfDaysOfSwiftUI
//
//  Created by Kohei Hayashi on 2021/12/27.
//

import SwiftUI

struct GuessTheFlagView: View {
    @State private var countries = [
        "estonia",
        "france",
        "germany",
        "ireland",
        "italy",
        "nigeria",
        "poland",
        "russia",
        "spain",
        "uk",
        "us"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                }

                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }

    private func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer
        ? "Correct"
        : "Wrong"

        showingScore = true
    }

    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct GuessTheFlagView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheFlagView()
    }
}
