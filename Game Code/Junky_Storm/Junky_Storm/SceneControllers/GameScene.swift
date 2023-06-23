//
//  GameScene.swift
//  Tester3_NC2
//
//  Created by Raffaele Martone on 07/12/22.
//

import SpriteKit
import GameplayKit
import AVFAudio
import AudioToolbox

struct FoodType{
    static let GOOD = 1
    static let BAD = 0
}

struct PhysicsCategory {
    static let BadFood : UInt32 = 0
    static let GoodFood : UInt32 = 1
    static let Player : UInt32 = 2
    static let Key : UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate  {
    var user : User?
    var player : SKNode?
    var pause : SKNode?
    var hearts : [SKNode] = []
    var fingerIsTouching : Bool = false
    var enemy : SKNode?
    var distanceLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var playerName : SKLabelNode?
    var continueBtn : SKNode?
    var exitBtn : SKNode?
    var pauseNode : SKNode?
    var background : SKNode?
    var difficulty : Int = 500
    
    var goodFood = ["candy_bar","cookies", "peanut_butter",
                    "potatochip_yellow", "snack1", "soft_drink_blue", "soft_drink_green", "soft_drink_red",
                        "wine_red"]
    var badFood = ["banana"]
    var badFoodTextures : [String: [SKTexture]] = [:]
    var goodFoodTextures : [String : [SKTexture]] = [:]
    
    var velocity: CGFloat = 0
    var distance : Float = 0{
        didSet{
            distanceLabel.text = "\(Int(distance)) mt"
        }
    }
    var score:Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    lazy var entranceEnemySound : AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: entranceEnemy, withExtension: extensMusic) else {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 0.5
            return player
        } catch {
            return nil
        }
    }()
    
    lazy var eatingSound : AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: eatSound, withExtension: extensMusic) else {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 1
            return player
        } catch {
            return nil
        }
    }()
    
    lazy var hittedSnd : AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: hittedSound, withExtension: extensMusic) else {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 5
            return player
        } catch {
            return nil
        }
    }()
    
    public func setUser(user: User){
        self.user = user
    }
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        getHearts()
        

        pauseNode=childNode(withName: "pauseNode")
        continueBtn=pauseNode?.childNode(withName: "continueBtn")
        exitBtn=pauseNode?.childNode(withName: "exitBtn")

        player=childNode(withName: "player")
        enemy=childNode(withName: "enemy")
        scoreLabel=childNode(withName: "score") as? SKLabelNode
        distanceLabel=childNode(withName: "distance") as? SKLabelNode
        pause=childNode(withName: "pause")
        playerName=childNode(withName: "playerName") as? SKLabelNode
        background=childNode(withName: "mainbackground")
        playerName?.text = user?.name
        player!.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player!.physicsBody?.contactTestBitMask = PhysicsCategory.GoodFood | PhysicsCategory.BadFood
        setUpTextures()
        moveEnemy()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == pause?.name {
                pauseNode?.position.y = 0
                pauseNode?.position.x = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    self.scene?.view?.isPaused = true
                }
            }else if(touchedNode.name == continueBtn?.name){
                pauseNode?.position.y = (pauseNode?.position.y)! - 1000.0
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){ [self] in
                    self.scene?.view?.isPaused = false
                }
            }else if(touchedNode.name == exitBtn?.name){
                
                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                ACTPlayerStats.instance.stopBackgroundMusic()
                self.scene?.view?.presentScene(scene)
               
                
            }else{
                fingerIsTouching = true
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            fingerIsTouching = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        distance += 0.5
        moveGrounds()
        simulatePhysicsOfPlayer()
    }
    
    func getHearts(){
        enumerateChildNodes(withName: "heart") { [self]
            (node, error) in
            hearts.append(node)
        }
    }
    
    func simulatePhysicsOfPlayer(){
        
        if fingerIsTouching{
            let position = player?.position
            if((player?.position.y)! < (0.21 * frame.size.height)){
                velocity += 0.5
            }
            player?.position.y = position!.y + velocity
        }else{
            if(velocity > 0){
                velocity -= 0.5
            }
            let position = player?.position
            player?.position.y = position!.y - 10 + velocity
        }
    }
    
    func moveEnemy(){
        
        let firstMove = SKAction.moveTo(x: (size.width * 0.4), duration: 1.5)
        let secondMove = SKAction.moveTo(y: -(size.height * 0.2), duration: 0.4)
        
        let actionMove1 = SKAction.moveTo(y: size.height * 0.18 , duration: 0.8)
        let actionMove2 = SKAction.moveTo(y: -(size.height * 0.25) , duration: 0.8)
        
        
        enemy?.run(firstMove){ [self] in
            let entranceAnimation = SKAction.sequence([
                SKAction.resize(toWidth: (enemy?.frame.width)! + 10, duration: 0.2),
                SKAction.resize(toWidth: (enemy?.frame.width)! - 10, duration: 0.2),
                SKAction.resize(toWidth: (enemy?.frame.width)! + 10, duration: 0.2),
                SKAction.resize(toWidth: (enemy?.frame.width)! - 10, duration: 0.2)
            ])
            self.entranceEnemySound?.play()
            self.enemy?.run(entranceAnimation){ [self] in
                ACTPlayerStats.instance.playBackgroundMusic(backgroundMusicString: mainBackgroundMusic, numOfLoops: -1, volume: 0.5)
                self.enemy?.run(secondMove){
                    self.enemy?.run(SKAction.repeatForever(SKAction.sequence([actionMove1,actionMove2])))
                    self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(self.spawnFood),SKAction.wait(forDuration:0.4)])))
                }
            }
        }
    }
    
    func setUpBadFoodTextures(){
        for food in badFood {
            var textures : [SKTexture] = []
            for i in 1...8 { //8 frame per ogni array
                textures.append(SKTexture(imageNamed: "\(food)\(i)"))
            }
            badFoodTextures[food] = textures
        }
    }
    
    func setUpGoodFoodTextures(){
        for food in goodFood {
            var textures : [SKTexture] = []
            textures.append(SKTexture(imageNamed: "\(food)"))
            goodFoodTextures[food] = textures
        }
    }
    
    func setUpTextures(){
        setUpBadFoodTextures()
        setUpGoodFoodTextures()
    }
    
    func spawnFood(){
        let random = UInt32.random(in: 0..<2)
        var food : SKSpriteNode
        if(random == FoodType.GOOD){
            let random = Int.random(in: 0..<goodFood.count)
            food = SKSpriteNode(texture: SKTexture(imageNamed: goodFood[random]),
                                                   size: CGSize(width: 70, height: 70))
        }else{
            
            let random = Int.random(in: 0..<badFood.count)
            let idleAnimation = SKAction.animate(with: badFoodTextures["banana"]!, timePerFrame: 0.1)
            
            food = SKSpriteNode(texture: badFoodTextures[badFood[random]]?.first,
                                size: CGSize(width: 70, height: 70))
            food.run(SKAction.repeatForever(idleAnimation))
        }
        food.position = enemy!.position
        food.zPosition = -1
        
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.categoryBitMask = (random == FoodType.GOOD ? PhysicsCategory.GoodFood : PhysicsCategory.BadFood)
        
        food.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = true
        
        addChild(food)
        let actionMove = SKAction.moveTo(x: -(size.width * 0.5), duration: 3)
        let actionRemove = SKAction.removeFromParent()
        food.run(SKAction.sequence([actionMove, actionRemove]))
        
    }
    
//    func RafEsterEgg(){
//
//        var key = SKSpriteNode(texture: SKTexture(imageNamed: "keyblade"))
//
//        key.position = enemy!.position
//        key.zPosition = -1
//        key.size = CGSize(width: 100, height: 100)
//
//        key.physicsBody = SKPhysicsBody(rectangleOf: key.size)
//        key.physicsBody?.categoryBitMask = (PhysicsCategory.Key)
//
//        key.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        key.physicsBody?.affectedByGravity = false
//        key.physicsBody?.isDynamic = true
//
//        addChild(key)
//        let actionMove = SKAction.moveTo(x: -(size.width * 0.5), duration: 2)
//        let actionRemove = SKAction.removeFromParent()
//        key.run(SKAction.sequence([actionMove, actionRemove]))
//    }
    
    
    func moveGrounds(){
        enumerateChildNodes(withName: (background?.name)!, using: ({
            (node, error) in
            node.position.x -= 5
            if (node.position.x < -((self.scene?.size.width)!)){
                node.position.x += (self.scene?.size.width)! * 2
            }
        }))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Player) && ((secondBody.categoryBitMask == PhysicsCategory.GoodFood) || (secondBody.categoryBitMask == PhysicsCategory.BadFood)) ){
            CollisionWithFood(player: firstBody.node as! SKSpriteNode, food: secondBody.node as! SKSpriteNode)
        }

    }
    
    func CollisionWithFood(player : SKSpriteNode, food: SKSpriteNode){
        
        if (food.physicsBody?.categoryBitMask == PhysicsCategory.GoodFood){
            eatingSound?.play()
            score += 1
        }else if(food.physicsBody?.categoryBitMask == PhysicsCategory.BadFood){
            self.hittedSnd?.play()
            SKAction.run() {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            let tmp = hearts.first
            if tmp != hearts.last {
                hearts.removeFirst()
                tmp?.removeFromParent()
            }else{
                isPaused = true
                let seconds = 1.0
                tmp?.removeFromParent()
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                    

                    let scene = SKScene(fileNamed: "GameOverScene") as? GameOverScene
                    self.user?.setDistance(distance: Int(self.distance))
                    self.user?.setScore(score: self.score)
                    scene?.setUser(user: self.user!)
                    scene?.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                    ACTPlayerStats.instance.stopBackgroundMusic()
                }
                
            }
        }
        food.removeFromParent()
    }
 
}
