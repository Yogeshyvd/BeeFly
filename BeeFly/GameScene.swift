//
//  GameScene.swift
//  BeeFly
//
//  Created by  on 3/4/16.
//  Copyright (c) 2016 Tuan_Quang. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let land: UInt32 = 0x1 << 1
    static let tree: UInt32 = 0x1 << 2
    static let bird: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var node = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let scoreNode = SKSpriteNode(imageNamed: "score.png")
        scoreNode.setScale(0.5)
        scoreNode.position = CGPointMake(self.size.width / 3 + 20, self.size.height - 40)
        scoreNode.zPosition = 3
        
        let lbl = SKLabelNode()
        lbl.text = String(100)
        scoreNode.addChild(lbl)
        
        self.addChild(scoreNode)
        
        let bg = SKSpriteNode(imageNamed: "background.png")
        bg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bg.zRotation = 0
        self.addChild(bg)
        
        /* Land */
        let land = SKSpriteNode(imageNamed: "land.png")
        land.setScale(0.5)
        land.position = CGPointMake(self.size.width / 2, 0 + land.frame.height / 2)
        land.zPosition = 2
        
        land.physicsBody = SKPhysicsBody(rectangleOfSize: land.frame.size)
        land.physicsBody?.categoryBitMask = PhysicsCategory.land
        land.physicsBody?.collisionBitMask = PhysicsCategory.bird
        land.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        land.physicsBody?.affectedByGravity = false
        land.physicsBody?.dynamic = false
        
        self.addChild(land)
        
        /* Bird */
        bird = SKSpriteNode(imageNamed: "bird_blue_1.png")
        bird.setScale(0.18)
        bird.zPosition = 1
        bird.position = CGPointMake(self.frame.width / 2, self.size.height / 2)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCategory.land | PhysicsCategory.tree
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.tree
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.dynamic = false
        
        let birdAct1 = SKTexture(imageNamed: "bird_blue_1")
        let birdAct2 = SKTexture(imageNamed: "bird_blue_2")
        let birdAct3 = SKTexture(imageNamed: "bird_blue_3")
        
        let birdFlySequence = SKAction.animateWithTextures([birdAct1, birdAct2, birdAct3], timePerFrame: NSTimeInterval(0.18))
        let birdFlyForever = SKAction.repeatActionForever(birdFlySequence)
        bird.runAction(birdFlyForever)
        
        self.addChild(bird)
    }
    
    func createTrees() {
        node = SKNode()
        
        let treeTop = SKSpriteNode(imageNamed: "tree.png")
        treeTop.setScale(0.5)
        treeTop.position = CGPointMake(self.size.width, self.size.height / 2 + 280)
        treeTop.zRotation = CGFloat(M_PI)
        treeTop.zPosition = 1
        
        treeTop.physicsBody = SKPhysicsBody(rectangleOfSize: treeTop.frame.size)
        treeTop.physicsBody?.categoryBitMask = PhysicsCategory.tree
        treeTop.physicsBody?.collisionBitMask = PhysicsCategory.bird
        treeTop.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        treeTop.physicsBody?.affectedByGravity = false
        treeTop.physicsBody?.dynamic = false
        
        node.addChild(treeTop)
        
        let treeBottom = SKSpriteNode(imageNamed: "tree.png")
        treeBottom.setScale(0.5)
        treeBottom.position = CGPointMake(self.size.width, self.size.height / 2 - 180)
        treeBottom.zPosition = 1
        
        treeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: treeBottom.frame.size)
        treeBottom.physicsBody?.categoryBitMask = PhysicsCategory.tree
        treeBottom.physicsBody?.collisionBitMask = PhysicsCategory.bird
        treeBottom.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        treeBottom.physicsBody?.affectedByGravity = false
        treeBottom.physicsBody?.dynamic = false
        
        node.addChild(treeBottom)
        
        let randomPos = CGFloat.random(min: -50, max: 50)
        node.position.y = node.position.y + randomPos
        node.runAction(moveAndRemove)
        
        self.addChild(node)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false {
            gameStarted = true
            let moveBackBird = SKAction.moveToX(self.frame.width / 2 - bird.frame.width, duration: 1)
            bird.runAction(moveBackBird)
            bird.physicsBody?.dynamic = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createTrees()
            })
            
            let delay = SKAction.waitForDuration(3.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + node.frame.width)
            let moveTrees = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.0098 * distance))
            let removeTrees = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveTrees, removeTrees])
            
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 120))
        } else {
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 120))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
