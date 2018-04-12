//
//  GameViewController.swift
//  BlockFrenzy
//
//  Created by Arsin Youkhana. on 3/8/18.
//  Copyright © 2018 McLoughlin David J. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func loadView() {
        
        
        let view = UIView()
        view.backgroundColor = .white
        view.sizeToFit()
        
        
        
        let play = UIButton(type: .roundedRect) as UIButton
        play.setTitle("PLAY GAME!", for: .normal)
        play.setTitleColor(UIColor.white, for: .normal)
        play.frame = CGRect(x: 290, y: 250, width: 150, height: 45)
        play.backgroundColor = UIColor.black
        play.addTarget(self, action: #selector(PlayGame), for: .touchUpInside)
        
        view.addSubview(play)
        self.view = view

    }
    
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    
    @IBAction func PlayGame() {
        
        
        let scene = GameScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        let skView = SKView()
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        self.view = skView
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
