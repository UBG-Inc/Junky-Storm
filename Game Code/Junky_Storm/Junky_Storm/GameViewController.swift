//
//  GameViewController.swift
//  Tester3_NC2
//
//  Created by Raffaele Martone on 07/12/22.
//

import UIKit
import SpriteKit
import AVFoundation
import GameplayKit

var audio : AVAudioPlayer!
var itemLB : [User] = itemsJSON


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SplashScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                //Setting the sound to true
            
                    ACTPlayerStats.instance.setSounds(true)

                
                // Present the scene
                view.presentScene(scene)
               
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    func run(_ fileName: String, onNode: SKNode){
        if(ACTPlayerStats.instance.getSound()){
            onNode.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

