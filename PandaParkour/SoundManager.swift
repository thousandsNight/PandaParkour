//
//  SoundManager.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SoundManager :SKNode{
    
    var bgMusicPlayer = AVAudioPlayer()
    let jumpAct = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
    let loseAct = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    let rollAct = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    let eatAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    func playBackgroundMusic(){
        let bgMusicURL:URL =  Bundle.main.url(forResource: "apple", withExtension: "mp3")!
        bgMusicPlayer = try! AVAudioPlayer(contentsOf: bgMusicURL as URL)
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.prepareToPlay()
        bgMusicPlayer.play()
    }
    func stopBackgroundMusic(){
        if bgMusicPlayer.isPlaying{
            bgMusicPlayer.stop()
        }
    }
    
    func playDead(){
        self.run(loseAct)
    }
    func playJump(){
        self.run(jumpAct)
    }
    func playRoll(){
        self.run(rollAct)
    }
    func playEat(){
        self.run(eatAct)
    }
    
}
