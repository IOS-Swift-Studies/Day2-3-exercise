//
//  player.swift
//  Day2-3-exercise
//
//  Created by Quyen Lu on 08/06/2022.
//

import Foundation
import AVFoundation

class MyPlayer {
    var player: AVAudioPlayer?
    var bgplayer: AVAudioPlayer?
    
    init() {
        playBGSound()
    }
    
    func playSound(fileName: String) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType:"wav") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
                
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func playBGSound() {
        
        guard let path = Bundle.main.path(forResource: "background", ofType:"wav") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            bgplayer = try AVAudioPlayer(contentsOf: url)
            bgplayer?.play()
                
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func isBGSoundPlayer() -> Bool {
        return bgplayer!.isPlaying
    }
    
    func stopSound() {
        player?.stop()
        bgplayer?.stop()
    }
    
}
