//
//  GameScene.swift
//  Hack and Share
//
//  Created by Avery Zakson on 10/2/20.
//  Copyright © 2020 Avery Zakson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var background = SKSpriteNode()
    var spongebob = SKSpriteNode()
    var patrick = SKSpriteNode()
    var flyingDutchman = SKSpriteNode()
    var startGame = false
    var dead = false
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    enum GameState {
        case playing
        case dead
    }
    
    
    override func didMove(to view: SKView) {
        createScene()
        spawnWalls()
        createScore()
        physicsWorld.contactDelegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gamePlay()
        startGame = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        
        if contact.bodyA.node?.name == "scoreZone" || contact.bodyB.node?.name == "scoreZone" {
            score += 1
            scoreLabel.text = "\(score)"
        } else if contact.bodyA.node?.name == "top" || contact.bodyB.node?.name == "top" {
            
            resetGame()
            
        } else if  contact.bodyA.node?.name == "bottom" || contact.bodyB.node?.name == "bottom" {
            
            resetGame()
            
        } else if  contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" {
            
            resetGame()
            
        }
    }
    
    @objc func createWalls() {
        let pipeTexture = SKTexture(imageNamed: "PipeUp")
        
        let topPipe = SKSpriteNode(texture: pipeTexture, size: CGSize(width: 75, height: 600))
        topPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: topPipe.size)
        topPipe.name = "top"
        topPipe.physicsBody?.isDynamic = false
        topPipe.zRotation = .pi
        topPipe.zPosition = 3
        topPipe.physicsBody?.categoryBitMask = 2
        topPipe.physicsBody?.contactTestBitMask = 1
        
        
        let bottomPipe = SKSpriteNode(texture: pipeTexture, size: CGSize(width: 75, height: 600))
        bottomPipe.physicsBody = SKPhysicsBody(texture: pipeTexture, size: bottomPipe.size)
        bottomPipe.name = "bottom"
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.zPosition = 3
        bottomPipe.physicsBody?.categoryBitMask = 2
        bottomPipe.physicsBody?.contactTestBitMask = 1
        
        
        let pipeCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 64, height:1500))
        pipeCollision.physicsBody = SKPhysicsBody(rectangleOf: pipeCollision.size)
        pipeCollision.physicsBody?.isDynamic = false
        pipeCollision.name = "scoreZone"
        pipeCollision.zPosition = 3
        pipeCollision.physicsBody?.categoryBitMask = 8
        pipeCollision.physicsBody?.contactTestBitMask = 1
        
        addChild(topPipe)
        addChild(bottomPipe)
        addChild(pipeCollision)
        
        let xPosition = frame.width + topPipe.frame.width
        
        let max = CGFloat(-105)
        let yPosition = CGFloat.random(in: -500...max)
        
        let pipeDistance: CGFloat = 90
        
        topPipe.position = CGPoint(x: xPosition, y: yPosition + topPipe.size.height + pipeDistance)
        bottomPipe.position = CGPoint(x: xPosition, y: yPosition - pipeDistance)
        pipeCollision.position = CGPoint(x: xPosition + (pipeCollision.size.width * 1.5), y: frame.midY)
        
        let endPosition = frame.width + (topPipe.frame.width * 6)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topPipe.run(moveSequence)
        bottomPipe.run(moveSequence)
        pipeCollision.run(moveSequence)
    }
    
    
    func spawnWalls() {
        
            let create = SKAction.run { [unowned self] in
                self.createWalls()
            }
            
            let wait = SKAction.wait(forDuration: 2.5)
            let sequence = SKAction.sequence([create, wait])
            let repeatForever = SKAction.repeatForever(sequence)
            run(repeatForever)
    }
    
    
    func createScene(){
        
        flyingDutchman = SKSpriteNode(imageNamed: "flyingDutchman")
        flyingDutchman.position = CGPoint(x: -56.25 , y: 0)
        flyingDutchman.size = CGSize(width: 80, height: 80)
        flyingDutchman.name = "dutchman"
        
        flyingDutchman.physicsBody = SKPhysicsBody(circleOfRadius: flyingDutchman.size.width / 2)
        flyingDutchman.physicsBody?.linearDamping = CGFloat(1.1)
        flyingDutchman.physicsBody?.restitution = 0
        flyingDutchman.physicsBody?.affectedByGravity = false
        flyingDutchman.physicsBody?.allowsRotation = false
        flyingDutchman.physicsBody?.isDynamic = true
        flyingDutchman.physicsBody?.categoryBitMask = 1
        flyingDutchman.physicsBody?.collisionBitMask = 7
        flyingDutchman.physicsBody?.contactTestBitMask = 15
        
        self.addChild(flyingDutchman)
        flyingDutchman.zPosition = 5
        
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.position = CGPoint(x: 0, y: frame.height / -2.25)
        ground.size = CGSize(width: 580, height: 130)
        ground.name = "ground"
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 4
        ground.physicsBody?.contactTestBitMask = 1
        
        self.addChild(ground)
        ground.zPosition = 4
        
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 45)
        background.size = CGSize(width: 560, height: 1000)
        self.addChild(background)
        background.zPosition = 0
        
        patrick = SKSpriteNode(imageNamed: "patrickStar")
        patrick.position = CGPoint(x: -84.375, y: frame.height / -2.6)
        patrick.size = CGSize(width: 90, height: 135)
        self.addChild(patrick)
        patrick.zPosition = 5
        
        spongebob = SKSpriteNode(imageNamed: "spongebobGhost")
        spongebob.position = CGPoint(x: -155, y: frame.height / -2.6)
        spongebob.size = CGSize(width: 140, height: 100)
        self.addChild(spongebob)
        spongebob.zPosition = 5
    }
    
    func gamePlay() {
        if startGame == true {
            flyingDutchman.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            flyingDutchman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
            flyingDutchman.physicsBody?.affectedByGravity = true
        }
    }
    
    func resetGame() {
        self.removeAllChildren()
        createScene()
        createScore()
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Marker Felt")
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.zPosition = 6
        
        addChild(scoreLabel)
    }
}

