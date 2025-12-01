//
//  SoundSystem.swift
//  DiceDuel
//
//  Created by Aiden Baker on 12/1/25.
//

import Foundation
import AVFoundation

enum SoundSystem {
    private static var player: AVAudioPlayer?
    
    private static func playSound(named sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "wav") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
    
    static func playStart() {
        playSound(named: "start")
    }
    static func playP1() {
        playSound(named: "p1")
    }
    static func playP2() {
        playSound(named: "p2")
    }
    static func playWin() {
        playSound(named: "win")
    }
}
