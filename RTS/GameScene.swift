//
//  GameScene.swift
//  RTS
//
//  Created by João Henrique Andrade on 06/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity


class GameScene: SKScene {
    lazy var gameController: GameController = GameController(gameScene: self)
    lazy var screenSize = self.frame
    
    // Trigger Boxes
    private var barracksTrigger = SKSpriteNode(color: SKColor.green, size: CGSize(width: 60, height: 60))
//    private var barracksTrigger = SKShapeNode(path: path)
    private var farmTrigger = SKSpriteNode(color: SKColor.red, size: CGSize(width: 30, height: 30))
    private var castleTrigger = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 60, height: 60))
    private var fieldSpace = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 60, height: 60))
    private var attackButton = SKSpriteNode(texture: SKTexture(imageNamed: "attackButton"), size: CGSize(width: 80, height: 80))
    
    // Popup
    private var popupNode = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: 500, height: 800))
    private var popupBackground = SKSpriteNode()
    private let backgroundNode = SKSpriteNode(imageNamed: "city_background.png")
    
    // HUD (Labels and buttons
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")
    private var archersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Archers")
    private var multiplierSelected: Int = 1
    private var multiplierNode = SKSpriteNode(color: SKColor.systemPink, size: CGSize(width: 60, height: 60))
    private var multiplierLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "1x")
    
    var soldiersAmountLabel = iOSLabelNode(fontSize: 30, fontColor: .white, text: "0")
    var army: Int = 0
    
    var sendArmyPopoverBtn =  SKSpriteNode(color: SKColor.purple, size: CGSize(width: 450, height: 80))
    
    #if TEST_VICTORY_CONDITIONS
    private var testGameOver = SKSpriteNode(color: SKColor.purple, size: CGSize(width: 60, height: 60))
    private var testGameWon = SKSpriteNode(color: SKColor.systemPink, size: CGSize(width: 60, height: 60))
    #endif
    
    var attackPopup: AttackPopup?
    
    override func didMove(to view: SKView) {
        self.addChild(backgroundNode)
        
        self.addChild(soldiersLabel)
        self.addChild(villagersLabel)
        self.addChild(farmersLabel)
        self.addChild(archersLabel)
        self.addChild(multiplierNode)
        self.addChild(fieldSpace)
        
        self.addChild(attackButton)
        
        self.addChild(barracksTrigger)
        self.addChild(farmTrigger)
        self.addChild(castleTrigger)
        
        #if TEST_VICTORY_CONDITIONS
        // test
        self.addChild(testGameWon)
        self.addChild(testGameOver)
        #endif
    }
    
    override func sceneDidLoad() {
        print("[iOS] GameScene: sceneDidLoad")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
    }
    
    func setupNodes(){
        farmTrigger.size = CGSize(width: screenSize.width/3 , height: screenSize.height/5)
        farmTrigger.position.x = CGFloat(-screenSize.width/5)
        farmTrigger.position.y = CGFloat(-screenSize.height/3)
        farmTrigger.zPosition = 2
        
        fieldSpace.size = CGSize(width: screenSize.width/3 , height: screenSize.height/5)
        fieldSpace.position.x = CGFloat(-screenSize.width/3.5)
        fieldSpace.position.y = CGFloat(-screenSize.height/8)
        fieldSpace.zPosition = 2
        
        barracksTrigger.size = CGSize(width: screenSize.width/2.5 , height: screenSize.height/5)
        barracksTrigger.position.x = CGFloat(screenSize.width/3.5)
        barracksTrigger.position.y = CGFloat(-screenSize.height/4)
        barracksTrigger.zPosition = 2
        
        castleTrigger.size = CGSize(width: screenSize.width/2.1 , height: screenSize.height/3)
        castleTrigger.position.x = CGFloat(screenSize.width/3.5)
        castleTrigger.position.y = CGFloat(screenSize.height/40)
        castleTrigger.zPosition = 2
        
        multiplierNode.position.x = CGFloat(screenSize.width/2 - multiplierNode.frame.width/2)
        multiplierNode.position.y += self.frame.height/2 - 80
        multiplierNode.addChild(multiplierLabel)
        multiplierNode.zPosition = 2
        multiplierLabel.zPosition = 3
        
        #if TEST_VICTORY_CONDITIONS
        // test
        testGameOver.position.x = 0
        testGameOver.position.y += self.frame.height/2 - 140
        testGameOver.zPosition = 2
        
        testGameWon.position.x = 0
        testGameWon.position.y += self.frame.height/2 - 200
        testGameWon.zPosition = 2
        // test end
        #endif
        
        soldiersLabel.position.y += self.frame.height/2 - 80
        farmersLabel.position.y += self.frame.height/2 - 120
        villagersLabel.position.y += self.frame.height/2 - 160
        archersLabel.position.y += self.frame.height/2 - 200
        
        attackButton.position.y = screenSize.height/2 - 1250
        attackButton.zPosition = 4
        
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        updateLabel()
        
        attackButton.name = "attackButton"
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let frontTouchedNode = self.atPoint(location)
        
        
        if (frontTouchedNode === attackButton)  {
            attackPopup = AttackPopup(castleNames: MultipeerController.shared.otherCastles.map({ (castle) -> String in
                castle.name
            }), scene: self)
            self.addChild(attackPopup!)
        } else if popupBackground.contains(location) && !popupNode.contains(location) {
            attackPopup?.removeFromParent()
            attackPopup = nil
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if (barracksTrigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.soldierInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (farmTrigger.contains(location) && gameController.castle.villager >= multiplierSelected && gameController.farmerInQueue + gameController.castle.farmer < 5) {
                gameController.farmerInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (castleTrigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
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
            #if TEST_VICTORY_CONDITIONS
            if testGameOver.contains(location) {
                gameOver()
            } else if testGameWon.contains(location) {
                gameWon()
            }
            #endif
            updateLabel()
        }
    }
    
    func gameOver() {
        let popupNode = SKSpriteNode(color: SKColor.lightGray, size: CGSize(width: 400, height: 400))
        self.addChild(popupNode)
        popupNode.zPosition = 10
        let popupLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Game Over")
        popupNode.addChild(popupLabel)
        self.isUserInteractionEnabled = false
    }
    
    func gameWon() {
        let popupNode = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: 400, height: 400))
        self.addChild(popupNode)
        popupNode.zPosition = 10
        let popupLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "You Won")
        popupNode.addChild(popupLabel)
        self.isUserInteractionEnabled = false
    }
    
    func draw() {
        let popupNode = SKSpriteNode(color: SKColor.lightGray, size: CGSize(width: 400, height: 400))
        self.addChild(popupNode)
        popupNode.zPosition = 10
        let popupLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Draw")
        popupNode.addChild(popupLabel)
        self.isUserInteractionEnabled = false
    }
}
