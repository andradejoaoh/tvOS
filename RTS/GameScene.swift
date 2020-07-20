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
    private var soldierInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private var farmerInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private var archerInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private let backgroundNode = SKSpriteNode(imageNamed: "castle.pdf")
    
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")
    private var archersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Archers")
    
    private var multiplierSelected: Int = 1
    private var multiplierNode = SKSpriteNode(color: SKColor.systemPink, size: CGSize(width: 60, height: 60))
    private var multiplierLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "1x")

    override func didMove(to view: SKView) {
        self.addChild(backgroundNode)
        
        self.addChild(soldiersLabel)
        self.addChild(villagersLabel)
        self.addChild(farmersLabel)
        self.addChild(archersLabel)
        self.addChild(multiplierNode)
        
        self.addChild(soldierInstance)
        self.addChild(farmerInstance)
        self.addChild(archerInstance)
    }
    
    override func sceneDidLoad() {
        print("[iOS] GameScene: sceneDidLoad")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
    }
    
    func setupNodes(){
        farmerInstance.size = CGSize(width: screenSize.width/2.3 , height: screenSize.height/1.6)
        farmerInstance.position.x = CGFloat(-screenSize.width/3.5)
        farmerInstance.position.y = CGFloat(-screenSize.height/4)
        farmerInstance.zPosition = 2
        
        soldierInstance.size = CGSize(width: screenSize.width/2.5 , height: screenSize.height/5)
        soldierInstance.position.x = CGFloat(screenSize.width/3.5)
        soldierInstance.position.y = CGFloat(-screenSize.height/4)
        soldierInstance.zPosition = 2

        archerInstance.size = CGSize(width: screenSize.width/2.1 , height: screenSize.height/3)
        archerInstance.position.x = CGFloat(screenSize.width/3.5)
        archerInstance.position.y = CGFloat(screenSize.height/40)
        archerInstance.zPosition = 2
        
        multiplierNode.position.x = CGFloat(screenSize.width/2 - multiplierNode.frame.width/2)
        multiplierNode.position.y += self.frame.height/2 - 80
        multiplierNode.addChild(multiplierLabel)
        multiplierNode.zPosition = 2
        multiplierLabel.zPosition = 3
        
        soldiersLabel.position.y += self.frame.height/2 - 80
        farmersLabel.position.y += self.frame.height/2 - 120
        villagersLabel.position.y += self.frame.height/2 - 160
        archersLabel.position.y += self.frame.height/2 - 200
        
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        updateLabel()
    }
    
    func updateLabel(){
        soldiersLabel.text = "Soldiers: \(gameController.castle.soldier)"
        villagersLabel.text = "Villagers: \(gameController.castle.villager)"
        farmersLabel.text = "Farmers: \(gameController.castle.farmer)"
        archersLabel.text = "Archers: \(gameController.castle.archer)"
        multiplierLabel.text = "\(multiplierSelected)x"
        
        if multiplierSelected > gameController.castle.villager {
            multiplierNode.color = UIColor.gray
        } else {
            multiplierNode.color = UIColor.green
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if (soldierInstance.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.soldierInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (farmerInstance.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.farmerInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (archerInstance.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.archerInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if multiplierNode.contains(location){
                switch multiplierSelected {
                case 1:
                    multiplierSelected = 5
                case 5:
                    multiplierSelected = 10
                case 10:
                    multiplierSelected = 20
                case 20:
                    multiplierSelected = 50
                default:
                    multiplierSelected = 1
                }
            }
            updateLabel()
        }
    }
}
