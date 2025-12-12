//
//  InstructionsView.swift
//  DiceDuel
//
//  Created by Aiden Baker on 12/12/25.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Dice Duel!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Goal")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Be the first player to reduce your opponent's HP to 0.")
                    Text("Turns & Scoring")
                        .font(.title2)
                        .fontWeight(.semibold)
                    VStack(alignment: .leading) {
                        Text("On your turn, tap your die to roll.")
                        Text("Your roll deals damage equal to the number shown (1–6) to your opponent's HP.")
                        Text("Rolling a 1: You heal +10 HP (up to a max of 50).")
                        Text("Rolling a 6: You keep your turn and may roll again.")
                    }
                    Text("Health (HP)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    VStack(alignment: .leading) {
                        Text("Each player starts with 50 HP.")
                        Text("Damage reduces the opponent's HP but never below 0.")
                        Text("Healing from rolling a 1 can't raise HP above 50.")
                    }
                    Text("Winning")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("The game ends immediately when a player's HP reaches 0. The other player wins!")
                }
                .padding()
            }
            .navigationTitle("How to Play")
        }
    }
}

#Preview {
    InstructionsView()
}
