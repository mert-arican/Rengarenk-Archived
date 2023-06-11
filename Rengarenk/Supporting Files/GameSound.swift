//
//  GameSound.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 24.01.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import Foundation
import AVFoundation

class GameSound {
    private static var soundPlayer: AVAudioPlayer!
    
    static func playTouch() { playSound(name: "imtouched.wav") }
    static var player: AVAudioPlayer?
    
    static func playSound(name: String) {
        guard UserPreferences.soundsIsOn, let url = Bundle.main.url(forResource: "\(name)", withExtension: nil) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            DispatchQueue.global(qos: .userInitiated).async {
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                
                guard let player = player else { return }
                
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
