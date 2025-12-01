//
//  ContentView.swift
//  DiceDuel
//
//  Created by Aiden Baker on 10/28/25.
//

import SwiftUI

// ContentView is the main view of our app
struct ContentView: View {
    @State private var randomValue1 = 1  // Player 1's die value
    @State private var randomValue2 = 1  // Player 2's die value
    @State private var rotation1 = 0.0  // Player 1's die rotation angle
    @State private var rotation2 = 0.0  // Player 2's die rotation angle
    @State private var hp1 = 50  // Player 1's health
    @State private var hp2 = 50  // Player 2's health
    @State private var isRolling = false
    @State private var currentRoller: Int? = nil  // Tracks which player (1 or 2) is currently rolling
    @State private var currentTurn = 1  // 1 = Player 1's turn, 2 = Player 2's turn
    @State private var gameState = "start"  // Can be: "start", "playing", or "ended"

    var body: some View {
        ZStack {
            if gameState == "start" {
                startScreen  // Show the start screen
            } else if gameState == "playing" {  // else if checks another condition
                gameScreen  // Show the game screen
            } else if gameState == "ended" {
                endScreen  // Show the end screen
            }
        }
    }
    
    var startScreen: some View {
        VStack(spacing: 30) {
            Text("DICE DUEL")
                .font(.system(size: 48, weight: .bold))

            Text("First to get their opponent's HP to 0 wins!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            Button(action: {
                SoundSystem.playStart()
                gameState = "playing"  // changes game state to playing
            }) {
                Text("START GAME")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
    
    var gameScreen: some View {
        VStack {

            VStack(spacing: 4) {  // Small spacing for compact HP display
                ProgressView(value: Double(hp1), total: 50)  // value: current, total: maximum
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                
                Text("HP: \(hp1)/50")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .rotationEffect(.degrees(180))
            .padding(.bottom, 8)
            
            // Player 1 label
            Text("P1")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(currentTurn == 1 ? .blue : .gray)  // Blue if P1's turn, gray otherwise
                .rotationEffect(.degrees(180))  // Rotated to match player 1's orientation
                .padding(.bottom, 4)
            
            // Player 1's die image
            Image("pips \(randomValue1)")
                .resizable()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation1))
                .rotation3DEffect(.degrees(rotation1), axis: (x: 1, y: 1, z: 0)) //3D logic from pig game!
                .rotationEffect(.degrees(180))
                .opacity(currentTurn != 1 ? 0.4 : 1.0)  // 0.4 = 40% opacity if not P1's turn
                .allowsHitTesting(currentTurn == 1)  // Only accepts taps when it's P1's turn
                .onTapGesture {
                    guard !isRolling, hp1 > 0, hp2 > 0, currentTurn == 1 else { return }
                    SoundSystem.playP1()
                    // This guard says continue only if NOT rolling AND hp1 > 0 AND hp2 > 0 AND it's P1's turn
                    isRolling = true  // Set rolling state to true
                    currentRoller = 1  // Set current roller to player 1
                    chooseRandom1(times: 3)  // Call function to roll 3 times animation
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation1 += 360
                    }
                }
            Spacer()
            
            Image("pips \(randomValue2)")
                .resizable()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation2))
                .rotation3DEffect(.degrees(rotation2), axis: (x: 1, y: 1, z: 0))
                .opacity(currentTurn != 2 ? 0.4 : 1.0)  // gray if not P2's turn
                .allowsHitTesting(currentTurn == 2)  // Only clickable on P2's turn
                .onTapGesture {
                    guard !isRolling, hp1 > 0, hp2 > 0, currentTurn == 2 else { return }
                    SoundSystem.playP2()
                    isRolling = true
                    currentRoller = 2
                    chooseRandom2(times: 3)
                    
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation2 += 360
                    }
                }
            
            // Player 2 label
            Text("P2")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(currentTurn == 2 ? .blue : .gray)
                .padding(.top, 4)
            
            // Player 2 HP display
            VStack(spacing: 4) {
                ProgressView(value: Double(hp2), total: 50)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                Text("HP: \(hp2)/50")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .frame(maxHeight: .infinity)
    }
    
    var endScreen: some View {
        VStack(spacing: 30) {
            Text("GAME OVER")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.primary)

            Text(hp1 <= 0 ? "PLAYER 2 WINS!" : "PLAYER 1 WINS!")
                .font(.system(size: 36, weight: .bold))
            VStack(spacing: 12) {
                HStack {
                    Text("Player 1:")
                        .font(.title2)
                    Spacer()
                    Text("\(hp1) HP")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Player 2:")
                        .font(.title2)
                    Spacer()
                    Text("\(hp2) HP")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Play again button
            Button(action: {
                resetGame()  // Call the reset function
            }) {
                Text("PLAY AGAIN")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
    // This function handles Player 1's dice rolling
    func chooseRandom1(times: Int) {
        if times > 0 {  // If there are rolls remaining
            // runs code to run after a delay to give the dice time to roll
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  // Wait 1 second
                // generates a random number based on 1 through 6
                randomValue1 = Int.random(in: 1...6)
                chooseRandom1(times: times - 1)
            }
        } else {
            let finalRoll = randomValue1
            // max(0, ...) ensures the value never goes below 0
            // subtracts from the existing value, hp2 = hp2 - finalRoll
            hp2 = max(0, hp2 - finalRoll)
            if finalRoll == 1 {
                hp1 = min(50, hp1 + 10)
            }
            isRolling = false
            currentRoller = nil
            // Check if game is over
            if hp2 <= 0 {  // If Player 2's HP is 0 or less
                SoundSystem.playWin()
                gameState = "ended"
                return  // Exit the function to go to the end  screen
            }
            
            // Check if rolled a 6 - if so, keep the turn, otherwise switch to player 2
            if finalRoll != 6 {  // not equal to 6
                currentTurn = 2  // Switch to Player 2's turn
            }
        }
    }
    func chooseRandom2(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue2 = Int.random(in: 1...6)
                chooseRandom2(times: times - 1)
            }
        } else {
            let finalRoll = randomValue2
            hp1 = max(0, hp1 - finalRoll)
            if finalRoll == 1 {
                hp2 = min(50, hp2 + 10)
            }
            isRolling = false
            currentRoller = nil
            // Check if game is over
            if hp1 <= 0 {
                SoundSystem.playWin()
                gameState = "ended"
                return
            }
            // Check if rolled a 6 - if so, keep the turn, otherwise switch to player 1
            if finalRoll != 6 {
                currentTurn = 1  // Switch to Player 1's turn
            }
        }
    }
    
    // This function resets all game variables to their starting values
    func resetGame() {
        hp1 = 50
        hp2 = 50
        randomValue1 = 1
        randomValue2 = 1
        rotation1 = 0.0
        rotation2 = 0.0
        currentTurn = 1
        isRolling = false  // Not rolling
        currentRoller = nil  // No current roller
        gameState = "start"
    }
}

#Preview {
    ContentView()
}
