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
    lazy var gameController: GameController = GameController(gameScene: self)
    
    private var trainningInstance = SKSpriteNode(color: SKColor.black, size: CGSize(width: 60, height: 60))
    private var farmInstance = SKSpriteNode(color: SKColor.green, size: CGSize(width: 60, height: 60))
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")

    
    override func didMove(to view: SKView) {
        self.addChild(soldiersLabel)
        self.addChild(villagersLabel)
        self.addChild(farmersLabel)
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
        farmInstance.position.y += 100
        soldiersLabel.position.y += self.frame.height/2 - 80
        farmersLabel.position.y += self.frame.height/2 - 120
        villagersLabel.position.y += self.frame.height/2 - 160
        updateLabel()
    }
    
    func updateLabel(){
        soldiersLabel.text = "Soldiers: \(gameController.castle.soldier)"
        villagersLabel.text = "Villagers: \(gameController.castle.villager)"
        farmersLabel.text = "Farmers: \(gameController.castle.farmer)"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if trainningInstance.contains(location) {
                gameController.soldierInQueue += 1
            } else if farmInstance.contains(location) {
                gameController.farmerInQueue += 1
            }
        }
    }
}
