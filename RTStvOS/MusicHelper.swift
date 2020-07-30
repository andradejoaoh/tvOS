//
//  MusicHelper.swift
//  RTStvOS
//
//  Created by Nathalia Melare on 28/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import AVFoundation
import SpriteKit

class MusicHelper {
    static let shared = MusicHelper()
    var audioPlayer : AVAudioPlayer!
    
    private init() { }
    
    func setupBackgroundMusic() {
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = .max
        } catch {
            print ("Music background wasn't found")
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.prepareToPlay()
    }
}
