//
//  GameView.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 14/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit

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
