//
//  PlaySound.swift
//  Tester3_NC2
//
//  Created by Raffaele Martone on 12/12/22.
//

import Foundation
import AVFoundation

var audioPlayer : AVAudioPlayer!

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer!.play()
            audioPlayer.volume = 20
        }catch{
            print("error1")
        }
    }
}
/*
func stopBackgroundMusic(){
    guard let audio = audio else {return}
    audio.stop()
}

func stopSound(){
    guard let audioPlayer = audioPlayer else{return}
    audioPlayer.stop()
}
*/
