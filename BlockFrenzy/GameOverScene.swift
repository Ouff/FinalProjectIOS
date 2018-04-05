//
//  GameOverScene.swift
//  BlockFrenzy
//
//  Created by McLoughlin David J. on 4/5/18.
//  Copyright © 2018 McLoughlin David J. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    init(size: CGSize, playerWon:Bool) {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: self.frame.midX,y: self.frame.midY)
        
        self.addChild(background)
        
        let gameOverlabal = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverlabal.fontSize = 54
        gameOverlabal.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        
        
        if playerWon {
            gameOverlabal.text = "YOU WIN!"
        }else {
            gameOverlabal.text = "GAME OVER!"
        }
        self.addChild(gameOverlabal)
        
        
    }
    
    func touchesBegan(_ touches: NSSet, with event: UIEvent?) {
        let blockFrenzyScene = GameScene(size:self.size)
        self.view?.presentScene(blockFrenzyScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
