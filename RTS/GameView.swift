//
//  ViewController.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit
import UIKit

class GameView: UIViewController {
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = SKView(frame: view.frame)
        if let view = self.view as! SKView? {
            guard let scene = SKScene(fileNamed: "GameScene") else { return }
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.translatesAutoresizingMaskIntoConstraints = false
            gameScene = (scene as! GameScene)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        gameScene.gameWon()
    }
    
}

