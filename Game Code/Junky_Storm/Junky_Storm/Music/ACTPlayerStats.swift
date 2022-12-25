//
//  ACTPlayerStats.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 13/12/22.
//

import Foundation
import SpriteKit
import AVFAudio

let kSoundState = "kSoundState"
let mainBackgroundMusic = "mainBackgroundMusic"
let entranceEnemy = "entranceEnemySound"
let eatSound = "eatSound"
let extensMusic = ".mp3"
let startBackgroundMusic = "startBackgroundMusic"
let hittedSound = "hittedSound"

enum SoundFileName: String {
    case mainBackground = "mainBackgroundMusic.mp3"
}

class ACTPlayerStats{
    private init(){}
    static let instance = ACTPlayerStats()
    private var backgroundMusic : AVAudioPlayer?
    private var backgroundMusicString : String?
    func setSounds(_ state : Bool){
        UserDefaults.standard.set(state, forKey: kSoundState)
        UserDefaults.standard.synchronize()
    }
    
    func getSound() -> Bool {
        return UserDefaults.standard.bool(forKey: kSoundState)
    }
    

    func playBackgroundMusic(backgroundMusicString : String, numOfLoops : Int, volume : Float = 10){
        self.backgroundMusicString = backgroundMusicString
        self.backgroundMusic = {
            guard let url = Bundle.main.url(forResource: backgroundMusicString, withExtension: extensMusic) else {
                return nil
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.numberOfLoops = numOfLoops
                player.volume = volume
                player.prepareToPlay()
                return player
            } catch {
                return nil
            }
        }()
        self.backgroundMusic?.play()
    }
    
    func stopBackgroundMusic(){
        if(self.backgroundMusic != nil){
            if((self.backgroundMusic?.isPlaying) != nil){
                self.backgroundMusic?.stop()
                
            }
        }
    }
    
    func getMusicPlaying() -> String{
        if((self.backgroundMusic?.isPlaying) != nil){
            if(self.backgroundMusic!.isPlaying){
                return self.backgroundMusicString ?? ""
            }
        }
        return ""
    }
}
