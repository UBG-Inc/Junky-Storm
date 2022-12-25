//
//  LeaderBoardScene.swift
//  Tester3_NC2
//
//  Created by Francesco De Stasio on 12/12/22.
//

import Foundation
import SpriteKit

class LeaderBoardScene : SKScene{
    
    var backbtn : SKNode?
    var first : SKLabelNode?
    var second : SKLabelNode?
    var third : SKLabelNode?
    
    var firsts : SKLabelNode?
    var seconds : SKLabelNode?
    var thirds : SKLabelNode?
    
    var LB : [User] = itemLB.sorted(by: { $0.score > $1.score })
    

    
    override func didMove(to view: SKView) {
        
        
        backbtn=childNode(withName: "backBtn")
        first = childNode(withName: "first") as? SKLabelNode
        second = childNode(withName: "second") as? SKLabelNode
        third = childNode(withName: "third") as? SKLabelNode
        firsts = childNode(withName: "score1") as? SKLabelNode
        seconds = childNode(withName: "score2") as? SKLabelNode
        thirds = childNode(withName: "score3") as? SKLabelNode

        if(LB.count > 2){
            first?.text = "\(String(describing: LB[0].name))"
            firsts?.text = "score: \(String(describing: LB[0].score)) (distance: \(String(describing: LB[0].distance)))"
            
            second?.text = "\(String(describing: LB[1].name))"
            seconds?.text = "score: \(String(describing: LB[1].score)) (distance: \(String(describing: LB[1].distance)))"
            
            third?.text = "\(String(describing: LB[2].name))"
            thirds?.text = "score: \(String(describing: LB[2].score)) (distance: \(String(describing: LB[2].distance)))"
        }else if LB.count > 1 {
                first?.text = "\(String(describing: LB[0].name))"
                firsts?.text = "score: \(String(describing: LB[0].score)) (distance: \(String(describing: LB[0].distance)))"
                
                second?.text = "\(String(describing: LB[1].name))"
                seconds?.text = "score: \(String(describing: LB[1].score)) (distance: \(String(describing: LB[1].distance)))"
        } else if LB.count > 0{
            first?.text = "\(String(describing: LB[0].name))"
            firsts?.text = "score: \(String(describing: LB[0].score)) (distance: \(String(describing: LB[0].distance)))"
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == backbtn?.name){
                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
    }
}
