//
//  ContentView.swift
//  DiceDuel
//
//  Created by Aiden Baker on 10/28/25.
//

import SwiftUI
struct ContentView: View {
    @State private var randomValue1 = 1
    @State private var randomValue2 = 1
    @State private var rotation1 = 0.0
    @State private var rotation2 = 0.0
    @State private var hp1 = 10
    @State private var hp2 = 10
    
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                ProgressView(value: Double(hp1), total: 10)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                Text("HP: \(hp1)/10")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            
            Image("pips \(randomValue1)")
                .resizable()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation1))
                .rotation3DEffect(.degrees(rotation1), axis: (x: 1, y: 1, z: 0))
                .onTapGesture {
                    chooseRandom1(times: 3)
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
                .onTapGesture {
                    chooseRandom2(times: 3)
                    withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                        rotation2 += 360
                    }
                }
            
            VStack(spacing: 4) {
                ProgressView(value: Double(hp2), total: 10)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 140)
                Text("HP: \(hp2)/10")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .frame(maxHeight: .infinity)
    }
    
    func chooseRandom1(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue1 = Int.random(in: 1...6)
                chooseRandom1(times: times - 1)
            }
        }
    }
    
    func chooseRandom2(times: Int) {
        if times > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                randomValue2 = Int.random(in: 1...6)
                chooseRandom2(times: times - 1)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
