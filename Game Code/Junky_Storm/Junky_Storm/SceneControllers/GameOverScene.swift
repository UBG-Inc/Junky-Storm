//
//  GameOverScene.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 09/12/22.
//

import Foundation

import SpriteKit

class GameOverScene : SKScene {
    
   // var coin : SKNode?
    var pig : SKSpriteNode?
    var pigIdleTextures : [SKTexture] = []
    var pigFinishTextures: [SKTexture] = []
    var pigFinishIdleTextures: [SKTexture] = []
    var countEsterEggPig : Int = 0
    var user : User!
    var player : String = ""
    var playerLabel : SKLabelNode?
    var scoreLabel : SKLabelNode?
    var saveScoreBtn : SKSpriteNode?
    var exitBtn : SKLabelNode?
    var distanceLabel : SKLabelNode?
    var score : Int = 0
    var distance: Int = 0
    var popup : SKNode?
    var popupLabel : SKLabelNode?
    
    override func didMove(to view: SKView) {
       // coin=childNode(withName: "coin")
        popup = childNode(withName: "gameoverback")
        popup?.run(SKAction.sequence(
            [SKAction.wait(forDuration: 2),
             SKAction.removeFromParent()]))
    
        
        pig=childNode(withName: "pig")  as? SKSpriteNode
        scoreLabel=childNode(withName: "score") as? SKLabelNode
        distanceLabel=childNode(withName: "distance") as? SKLabelNode
        saveScoreBtn=childNode(withName: "saveBtn") as? SKSpriteNode
        exitBtn=childNode(withName: "exitbtn") as? SKLabelNode
        playerLabel=childNode(withName: "player") as? SKLabelNode
        
        saveData()
        distanceLabel?.text = "Distance: \(user.distance)"
        scoreLabel?.text = "Score: \(user.score)"
        playerLabel?.text = "Player: \(user.name)"
        
        setUpTextures()
        startPigIdle()
    }
    
    
    public func saveData(){
        if itemLB.last?.name == user.name{
            if (itemLB.last?.score)!  < user.score {
                itemLB.last?.score = user.score
            }
        } else {
            itemLB.append(user)
        }
        savePack("leaderboard", itemLB)
    }
    
    
    public func setUser(user: User){
        self.user = user
        if(self.user != nil){
            player = user.name
            score = user.score
            distance = user.distance
        }
    }
    
    func setUpTextures() {
        for i in 1...9{
            let texture_name = "pig\(i)"
            pigIdleTextures.append(SKTexture(imageNamed: texture_name))
        }
        
        
        for i in 1...12 {
            let texture_name = "pigfinish\(i)"
            pigFinishTextures.append(SKTexture(imageNamed: texture_name))
        }
        
        for i in 1...12 {
            let texture_name = "pigidlefinish\(i)"
            pigFinishIdleTextures.append(SKTexture(imageNamed: texture_name))
        }
    }
    
    func startPigIdle(){
        let idleAnimation = SKAction.animate(with: pigIdleTextures, timePerFrame: 0.1)
        pig?.run(SKAction.repeatForever(idleAnimation), withKey: "pigIdleAnimation")
        pig?.run(SKAction.sequence(
            [SKAction.moveTo(y: (pig?.position.y)! + 10.0, duration: 0.5),
             SKAction.moveTo(y: (pig?.position.y)! - 10.0, duration: 0.5)]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "pig"){
                countEsterEggPig += 1
                if(countEsterEggPig == 5){
                    let scene = SKScene(fileNamed: "StuEsterEggScene") as? StuEsterEggScene
                    scene?.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }else{
                    pig?.removeAction(forKey: "pigIdleAnimation")
                    let finishAnimation = SKAction.animate(with: pigFinishTextures, timePerFrame: 0.05)
                    let finishIdleAnimation = SKAction.animate(with: pigFinishIdleTextures, timePerFrame: 0.05)
                    
                    pig?.run(SKAction.sequence([
                            finishAnimation, finishIdleAnimation])){
                                let scene = SKScene(fileNamed: "GameScene") as? GameScene
                                scene?.scaleMode = .aspectFill
                                scene?.setUser(user: self.user)
                                self.view?.presentScene(scene)
                            }
                }
                
                
            }else if(touchedNode.name == exitBtn?.name){
                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }else if(touchedNode.name == "saveBtn"){
                
            }
        }
    }
    
    
//    func moveCoin(){
//        coin!.run(
//            SKAction.repeatForever(SKAction.sequence([
//                SKAction.moveTo(y: (coin?.position.y)! + 10.0, duration: 0.5), SKAction.moveTo(y:  (coin?.position.y)! - 10.0, duration: 0.5)])))
//
//    }
    
   
}
