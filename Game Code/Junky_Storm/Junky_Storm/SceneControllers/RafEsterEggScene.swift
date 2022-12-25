//
//  RafEsterEggScene.swift
//  Tester3_NC2
//
//  Created by Raffaele Martone on 11/12/22.
//

import Foundation
import SpriteKit

class RafEsterEggScene : SKScene {
    
    var key : SKSpriteNode?
    

    override func didMove(to view: SKView) {
        key=childNode(withName: "key") as? SKSpriteNode
            
        playSound(sound: "AUD-20191112-WA0089", type: ".m4a")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "key"){
                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
    
    func moveKey(){
        enumerateChildNodes(withName: "key", using: ({
            (node,error) in
            node.run(SKAction.repeatForever(
                SKAction.rotate(toAngle: CGFloat(2 * 3.14), duration: TimeInterval(10))))
        }))
    }
    
}
