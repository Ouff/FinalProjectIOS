//
//  GameScene.swift
//  BlockFrenzy
//
//  Created by McLoughlin David J. on 3/8/18.
//  Copyright © 2018 McLoughlin David J. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCatName = "ball"
    let paddleCatName = "paddle"
    let BlockCatName = "block"
    
    
    var BackgroundMusic = AVAudioPlayer()
    var fingerIsOnpaddle = false
    
    let ballCat:UInt32 = 0x1 << 0
    let bottomCat:UInt32 = 0x1 << 1
    let blockCat:UInt32 = 0x1 << 2
    let paddleCat:UInt32 = 0x1 << 3
    
    override init(size: CGSize) {
        super.init(size: size)
        
        guard let bgMusic = Bundle.main.url(forResource: "Dark_Knight_Dummo", withExtension: "mp3") else {
            return
        }
        
        do {
            
            
            self.physicsWorld.contactDelegate = self
            
            
            try BackgroundMusic = AVAudioPlayer(contentsOf: bgMusic)
            BackgroundMusic.numberOfLoops = -1;
            BackgroundMusic.prepareToPlay()
            BackgroundMusic.play()
            
            let backgoundImage = SKSpriteNode(imageNamed: "bg")
            backgoundImage.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.addChild(backgoundImage)
            
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            
            let border = SKPhysicsBody(edgeLoopFrom: self.frame)
            self.physicsBody = border
            self.physicsBody?.friction = 0
            
            let ball = SKSpriteNode(imageNamed: "Ball")
            ball.name = BallCatName
            ball.position = CGPoint(x: self.frame.size.width/4, y: self.frame.size.width/4)
            self.addChild(ball)
            ball.setScale(2)
            
            
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
            ball.physicsBody?.friction = 0
            ball.physicsBody?.restitution = 1.0
            ball.physicsBody?.linearDamping = 0
            ball.physicsBody?.allowsRotation = false
            
            
            ball.physicsBody?.applyImpulse(CGVector(dx: 2, dy: -2))
            
            let paddle = SKSpriteNode(imageNamed: "paddle")
            paddle.name = paddleCatName
            paddle.position = CGPoint(x: self.frame.midX, y: paddle.frame.size.height * 2)
            
            self.addChild(paddle)
            paddle.setScale(1.5)

            paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
            paddle.physicsBody?.friction = 0.4
            paddle.physicsBody?.restitution = 0.1
            paddle.physicsBody?.isDynamic = false
            
            
            let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
            
            let bottom = SKNode()
            bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
            self.addChild(bottom)
            
            
            bottom.physicsBody?.categoryBitMask = bottomCat
            ball.physicsBody?.categoryBitMask = ballCat
            paddle.physicsBody?.categoryBitMask = paddleCat
            
            ball.physicsBody?.contactTestBitMask = bottomCat | blockCat
            
            let numberOfRows = 3
            let numbersOfBricks = 10
            let brickWidth = SKSpriteNode(imageNamed: "paddle").size.width
            let padding:Float = 20
            
            let offSet = (Float(self.frame.size.width) - (Float(brickWidth) * Float(numbersOfBricks) + padding * (Float(numbersOfBricks) - 1 ) ) ) / 2
            
            for index in 1 ... numberOfRows {
                
                var yOffset:CGFloat {
                    switch index {
                    case 1:
                        return self.frame.size.height * 0.8
                    case 2:
                        return self.frame.size.height * 0.6
                    case 3:
                        return self.frame.size.height * 0.4
                    default:
                        return 0
                    }
                }
                
                for index in 1 ... numbersOfBricks {
                    let brick = SKSpriteNode(imageNamed: "blocks")
                    
                    let calc1:Float = Float(index) - -5
                    let calc2:Float = Float(index) - 1
                    
                    brick.position = CGPoint(x:CGFloat(calc1 * Float(brick.frame.size.width) + calc2 * padding + offSet),y: yOffset)
                    
                    brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
                    brick.physicsBody?.allowsRotation = false
                    brick.name = BlockCatName
                    brick.physicsBody?.categoryBitMask = blockCat
                    brick.physicsBody?.isDynamic = false
                    self.addChild(brick)
                    
                }
                
            }
            
            
            
        } catch{
            print(error)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
    
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let body:SKPhysicsBody? = self.physicsWorld.body(at: touchLocation)
        
        if body?.node?.name == paddleCatName {
            print("paddle touched")
            fingerIsOnpaddle = true
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if fingerIsOnpaddle {
            guard let touch = touches.first else {
                return
            }
            let touchLoc = touch.location(in: self)
            let prevTouchLocation = touch.previousLocation(in: self)
            
            let paddle = self.childNode(withName: paddleCatName) as! SKSpriteNode
            
            var newXPos = paddle.position.x + (touchLoc.x - prevTouchLocation.x)
            
            
            
            newXPos = max(newXPos,paddle.size.width / 2)
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
            
            paddle.position = CGPoint(x: newXPos, y: paddle.position.y)
            
        }
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        fingerIsOnpaddle = false
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if firstBody.categoryBitMask == ballCat && secondBody.categoryBitMask == bottomCat {
            print("you Lost!")
            let gameOverScene = GameOverScene(size:self.frame.size, playerWon: false)
            self.view?.presentScene(gameOverScene)
        }

        if firstBody.categoryBitMask == ballCat && secondBody.categoryBitMask == blockCat {
            secondBody.node?.removeFromParent()
            
            if isGameWon(){
                print("You Won!")
                let youWinScene = GameOverScene(size: self.frame.size, playerWon: true)
                self.view?.presentScene(youWinScene)
            }
            
        }
        
        
    }
    
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        
        for nodeObject in self.children{
            let node = nodeObject as SKNode
            if node.name == BlockCatName {
                numberOfBricks += 1
            }
        }
        return numberOfBricks <= 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
