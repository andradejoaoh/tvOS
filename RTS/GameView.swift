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
    
    let gameScene: GameScene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            guard let scene = SKScene(fileNamed: "GameScene") else { return }
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
}

