//
//  SplashScene.swift
//  Tester3_NC2
//
//  Created by Raffaele Martone on 15/12/22.
//

import Foundation
import SpriteKit

class SplashScene : SKScene{
    
    var title = SKSpriteNode(imageNamed: "title1")
    var back : SKNode?
    var alphat = 0.1
    
    
    override func didMove(to view: SKView) {
        
            back = childNode(withName: "quadri")
        back?.run(SKAction.resize(toWidth: (back?.frame.width)! * 1.5, duration: 3))
        back?.run(SKAction.resize(toHeight: (back?.frame.height)! * 1.5, duration: 3))
        back?.run(SKAction.rotate(byAngle: 3.14, duration: 30))
        title.size = CGSize(width:  960.4 , height: 101.5 )
        title.alpha = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                addChild(title)             }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [self] in
            title.alpha += 0.1              }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) { [self] in
            title.alpha += 0.1            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
            title.alpha += 0.1            }
            
        // title?.run(SKAction.rotate(byAngle: 12 * 3.14, duration: 3))
        
        let scene = SKScene(fileNamed: "StartScene") as? StartScene
        scene?.scaleMode = .aspectFill
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            self.view?.presentScene(scene)
        }

        
    }
}
