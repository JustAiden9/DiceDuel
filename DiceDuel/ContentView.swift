//
//  ContentView.swift
//  DiceDuel
//
//  Created by Aiden Baker on 10/28/25.
//

import SwiftUI

struct ContentView: View {
    // Game state for each die face (1-6)
    @State private var randomValue1 = 1
    @State private var randomValue2 = 1
    // Rotation amounts used only for visuals/animation
    @State private var rotation1 = 0.0
    @State private var rotation2 = 0.0
    // Hit points for the two players (0-100)
    @State private var hp1 = 100
    @State private var hp2 = 100
    // Prevents both dice from rolling at the same time
    @State private var isRolling = false
    @State private var currentRoller: Int? = nil
    // Track whose turn it is (1 or 2)
    @State private var currentTurn = 1
    
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                ProgressView(value: Double(hp1), total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                Text("HP: \(hp1)/100")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .rotationEffect(.degrees(180))
            .padding(.bottom, 8)
            Image("pips \(randomValue1)")
                .resizable()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation1))
                .rotation3DEffect(.degrees(rotation1), axis: (x: 1, y: 1, z: 0))
                .rotationEffect(.degrees(180))
                .opacity(currentTurn != 1 ? 0.4 : 1.0)
                .allowsHitTesting(currentTurn == 1)
                .onTapGesture {
                    // Stop if we're already rolling or someone has 0 HP or not player 1's turn
                    guard !isRolling, hp1 > 0, hp2 > 0, currentTurn == 1 else { return }
                    isRolling = true
                    currentRoller = 1
                    // Roll 3 times using simple recursion with delays; handles damage internally
                    chooseRandom1(times: 3)
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation1 += 360
                    }
                }
            Spacer()
            // Bottom die image (Player 2 attacks Player 1)
            Image("pips \(randomValue2)")
                .resizable()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation2))
                .rotation3DEffect(.degrees(rotation2), axis: (x: 1, y: 1, z: 0))
                .opacity(currentTurn != 2 ? 0.4 : 1.0)
                .allowsHitTesting(currentTurn == 2)
                .onTapGesture {
                    // Stop if we're already rolling or someone has 0 HP or not player 2's turn
                    guard !isRolling, hp1 > 0, hp2 > 0, currentTurn == 2 else { return }
                    isRolling = true
                    currentRoller = 2
                    // Roll 3 times using simple recursion with delays; handles damage internally
                    chooseRandom2(times: 3)
                    // Keep the existing visual spin
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation2 += 360
                    }
                }
            VStack(spacing: 4) {
                ProgressView(value: Double(hp2), total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                Text("HP: \(hp2)/100")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .frame(maxHeight: .infinity)
    }

    // Simpler timer-based rolling for the top die (Player 1)
    func chooseRandom1(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue1 = Int.random(in: 1...6)
                chooseRandom1(times: times - 1)
            }
        } else {
            // Rolling finished for Player 1: apply damage to Player 2
            let finalRoll = randomValue1
            hp2 = max(0, hp2 - finalRoll)
            isRolling = false
            currentRoller = nil
            // Switch to player 2's turn
            currentTurn = 2
        }
    }

    // Simpler timer-based rolling for the bottom die (Player 2)
    func chooseRandom2(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue2 = Int.random(in: 1...6)
                chooseRandom2(times: times - 1)
            }
        } else {
            // Rolling finished for Player 2: apply damage to Player 1
            let finalRoll = randomValue2
            hp1 = max(0, hp1 - finalRoll)
            isRolling = false
            currentRoller = nil
            // Switch to player 1's turn
            currentTurn = 1
        }
    }
}

#Preview {
    ContentView()
}
