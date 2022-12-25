//
//  StuEsterEggScene.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 10/12/22.
//

import Foundation
import SpriteKit

class StuEsterEggScene : SKScene {
    
    var coin : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        coin=childNode(withName: "coin") as? SKSpriteNode
        moveCoin()
    }
    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "coin"){
                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
    
    func moveCoin(){
        enumerateChildNodes(withName: "coin", using: ({
            (node,error) in
            node.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(y: (node.position.y + 10.0), duration: 1),
                    SKAction.moveTo(y: (node.position.y - 10.0), duration: 1)])))
        }))
    }
    
    func moveGrounds(){
        enumerateChildNodes(withName: "background", using: ({
            (node, error) in
            node.position.x -= 5
            if (node.position.x < -((self.scene?.size.width)!)){
                node.position.x += (self.scene?.size.width)! * 2
            }
        }))
        
    }
}
