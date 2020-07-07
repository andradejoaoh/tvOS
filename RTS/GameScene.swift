//
//  GameScene.swift
//  RTS
//
//  Created by João Henrique Andrade on 06/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var trainningInstance = SKSpriteNode(color: SKColor.black, size: CGSize(width: 32, height: 32))
    var farmInstance = SKSpriteNode(color: SKColor.green, size: CGSize(width: 32, height: 32))
    var soldiersLabel = SKLabelNode(fontNamed: "Arial")
    
    
    override func didMove(to view: SKView) {
        self.addChild(soldiersLabel)
        self.addChild(trainningInstance)
        self.addChild(farmInstance)
    }
    
    override func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFill
        self.backgroundColor = SKColor.white
        
        setupNodes()

    }
    
    func setupNodes(){
        soldiersLabel.text = "Soldiers"
        soldiersLabel.fontSize = 32
        soldiersLabel.fontColor = .black
        farmInstance.position.y += 40
        soldiersLabel.position.y -= 40

    }
}
