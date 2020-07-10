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
    lazy var screenSize = self.frame
    private var trainningInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private var farmInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private let backgroundNode = SKSpriteNode(imageNamed: "castle.pdf")
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")

    
    override func didMove(to view: SKView) {
        self.addChild(backgroundNode)
        self.addChild(soldiersLabel)
        self.addChild(villagersLabel)
        self.addChild(farmersLabel)
        self.addChild(trainningInstance)
        self.addChild(farmInstance)
    }
    
    override func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
    }
    
    func setupNodes(){
        farmInstance.size = CGSize(width: screenSize.width/2.3 , height: screenSize.height/1.6)
        farmInstance.position.x = CGFloat(-screenSize.width/3.5)
        farmInstance.position.y = CGFloat(-screenSize.height/4)
        farmInstance.zPosition = 2
        
        trainningInstance.size = CGSize(width: screenSize.width/2.5 , height: screenSize.height/5)
        trainningInstance.position.x = CGFloat(screenSize.width/3.5)
        trainningInstance.position.y = CGFloat(-screenSize.height/4)
        trainningInstance.zPosition = 2

        
        soldiersLabel.position.y += self.frame.height/2 - 80
        farmersLabel.position.y += self.frame.height/2 - 120
        villagersLabel.position.y += self.frame.height/2 - 160
        
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
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
