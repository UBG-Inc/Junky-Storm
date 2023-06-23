//
//  StartScene.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 09/12/22.
//

import Foundation
import SpriteKit
import AVFAudio

class StartScene : SKScene {
    var startBtn : SKNode?
    var leaderBoardBtn : SKNode?
    
    var EERF : SKNode?
    
    let entryMove = SKAction.moveTo(x: -700, duration: 10)
    let actionMove = SKAction.rotate(byAngle: 2 * 3.14, duration: 30)
    let actionRemove = SKAction.removeFromParent()
    
    
    private lazy var backgroundMusic : AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: startBackgroundMusic, withExtension: extensMusic) else {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.prepareToPlay()
            return player
        } catch {
            return nil
        }
    }()
    
    override func didMove(to view: SKView) {
        startBtn=childNode(withName: "startBtn")
        leaderBoardBtn=childNode(withName: "leaderBoardBtn")
        EERF = childNode(withName: "eerf")
        EERF?.run(SKAction.sequence([actionMove,entryMove, actionRemove]))
        if(ACTPlayerStats.instance.getMusicPlaying() == startBackgroundMusic){
            
        }else{
            ACTPlayerStats.instance.playBackgroundMusic(backgroundMusicString: startBackgroundMusic, numOfLoops: -1, volume: 2)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "startBtn"){
                
                let user = User(score: 0, distance: 0)
                let scene = SKScene(fileNamed: "GameScene") as? GameScene
                scene?.setUser(user: user)
                scene?.scaleMode = .aspectFill
                view?.presentScene(scene)
                ACTPlayerStats.instance.stopBackgroundMusic()
            }else if(touchedNode.name == leaderBoardBtn?.name){
                let scene = SKScene(fileNamed: "LeaderBoardScene") as? LeaderBoardScene
                scene?.scaleMode = .aspectFill
                view?.presentScene(scene)
            }

        }
    }
}
