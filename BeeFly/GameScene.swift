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
    static let score: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var node = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score: Int = 0
    var lblScore = SKLabelNode()
    var died = Bool()
    
    var btnReload = SKSpriteNode()
    var btnMenu = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.createStartGameScene()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyContactA = contact.bodyA
        let bodyContactB = contact.bodyB
        
        if bodyContactA.categoryBitMask == PhysicsCategory.tree && bodyContactB.categoryBitMask == PhysicsCategory.bird || bodyContactB.categoryBitMask == PhysicsCategory.tree && bodyContactA.categoryBitMask == PhysicsCategory.bird || bodyContactA.categoryBitMask == PhysicsCategory.land && bodyContactB.categoryBitMask == PhysicsCategory.bird || bodyContactB.categoryBitMask == PhysicsCategory.land && bodyContactA.categoryBitMask == PhysicsCategory.bird {
            died = true
            
            self.removeAllActions()
            node.removeAllActions()
            bird.removeAllActions()
            
            self.createRestartGameScene()
            
            let birdAct3 = SKTexture(imageNamed: "bird_blue_4")
            let changeAct = SKAction.animateWithTextures([birdAct3], timePerFrame: NSTimeInterval(0.2))
            bird.runAction(changeAct)
        }
        
        if bodyContactA.categoryBitMask == PhysicsCategory.score && bodyContactB.categoryBitMask == PhysicsCategory.bird || bodyContactB.categoryBitMask == PhysicsCategory.score && bodyContactA.categoryBitMask == PhysicsCategory.bird {
            score++
            lblScore.text = String(score)
        }
    }
    
    func createStartGameScene() {
        self.physicsWorld.contactDelegate = self
        
        let src = SKSpriteNode(imageNamed: "score.png")
        src.position = CGPointMake(self.size.width / 3 + 20, self.size.height - 40)
        src.zPosition = 4
        src.setScale(0.5)
        
        lblScore = SKLabelNode(fontNamed: "debussy")
        lblScore.text = String(0)
        lblScore.zPosition = 4
        lblScore.fontSize = 40
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblScore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        src.addChild(lblScore)
        
        self.addChild(src)
        
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
        bird.setScale(0.15)
        bird.zPosition = 1
        bird.position = CGPointMake(self.frame.width / 2, self.size.height / 2)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCategory.land | PhysicsCategory.tree
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.tree | PhysicsCategory.score
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
    
    func createRestartGameScene() {
        let restartGame = SKNode()
        restartGame.zPosition = 6
        
        let bg = SKSpriteNode(imageNamed: "info-background.png")
        bg.position = CGPointMake(self.frame.width / 2, self.frame.height / 2 + 50)
        
        btnReload = SKSpriteNode(imageNamed: "btn-reload")
        btnReload.position = CGPointMake(self.frame.width / 2 - 60, self.frame.height / 2 + 30)
        btnReload.zPosition = 7
        self.addChild(btnReload)
        
        btnMenu = SKSpriteNode(imageNamed: "btn-menu")
        btnMenu.position = CGPointMake(self.frame.width / 2 + 60, self.frame.height / 2 + 30)
        btnMenu.zPosition = 7
        self.addChild(btnMenu)
        
        restartGame.addChild(bg)
        self.addChild(restartGame)
    }
    
    func createTrees() {
        node = SKNode()
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 400)
        scoreNode.position = CGPointMake(self.frame.width, self.frame.height / 2)
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false

        
        let treeTop = SKSpriteNode(imageNamed: "tree.png")
        treeTop.setScale(0.5)
        treeTop.position = CGPointMake(self.size.width, self.size.height / 2 + 265)
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
        treeBottom.position = CGPointMake(self.size.width, self.size.height / 2 - 185)
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
        node.addChild(scoreNode)
        
        self.addChild(node)
    }
    
    func actRestartGame() {
        gameStarted = false
        score = 0
        died = false
        self.removeAllChildren()
        self.createStartGameScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false {
            gameStarted = true
            let moveBackBird = SKAction.moveToX(self.frame.width / 2 - bird.frame.width, duration: 4)
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
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 70))
        } else {
            if !died {
                bird.physicsBody?.velocity = CGVectorMake(0, 0)
                bird.physicsBody?.applyImpulse(CGVectorMake(0, 70))
            } else {
                for touch in touches {
                    let location = touch.locationInNode(self)
                    if btnReload.containsPoint(location) {
                        self.actRestartGame()
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
