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
    private var soldierInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private var farmerInstance = SKSpriteNode(color: SKColor.red, size: CGSize(width: 60, height: 60))
    private var archerInstance = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 60, height: 60))
    private var attackButton = SKSpriteNode(texture: SKTexture(imageNamed: "attackButton"), size: CGSize(width: 80, height: 80))
    private var popupNode = SKSpriteNode(color: SKColor.cyan, size: CGSize(width: 500, height: 800))
    private var popupBackground = SKSpriteNode()
    private let backgroundNode = SKSpriteNode(imageNamed: "castle.pdf")
    
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")
    private var archersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Archers")
    
    private var multiplierSelected: Int = 1
    private var multiplierNode = SKSpriteNode(color: SKColor.systemPink, size: CGSize(width: 60, height: 60))
    private var multiplierLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "1x")
    
    var castle1PopoverSection = SKSpriteNode(color: SKColor.black, size: CGSize(width: 450, height: 80))
    
    var minusTroop = SKSpriteNode(color: SKColor.white, size: CGSize(width: 50, height: 50))
    var plusTroop = SKSpriteNode(color: SKColor.systemGray2, size: CGSize(width: 50, height: 50))
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
        
        self.addChild(attackButton)
        
        self.addChild(soldierInstance)
        self.addChild(farmerInstance)
        self.addChild(archerInstance)
        
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
        //        popupSetup()
    }
    
    func popupSetup()  {
        popupNode.zPosition = 6
        popupBackground.zPosition = 5
        popupBackground.size = CGSize(width: self.frame.width, height: self.frame.height)
        popupBackground.color = UIColor.black
        popupBackground.alpha = 0.5
        sendArmyPopoverBtn.position.y = popupNode.size.height/2 - 700
        
        for _ in MultipeerController.shared.otherCastles {
            // section: minus/plus -> label -> section -> popup
            castle1PopoverSection.position.y = popupNode.size.height/2 - 80
            minusTroop.position.x = castle1PopoverSection.size.width/5 - 30
            plusTroop.position.x =  castle1PopoverSection.size.height/2 + 140
            minusTroop.name = "minusTroop"
            plusTroop.name = "plusTroop"
            soldiersAmountLabel.position.x = castle1PopoverSection.size.width/5 + 30
            soldiersAmountLabel.position.y = castle1PopoverSection.size.height/2 - 50
            castle1PopoverSection.addChild(minusTroop)
            castle1PopoverSection.addChild(plusTroop)
            castle1PopoverSection.addChild(soldiersAmountLabel)
        }
        
        self.addChild(popupBackground)
        self.addChild(popupNode)
        popupNode.addChild(castle1PopoverSection)
        popupNode.addChild(sendArmyPopoverBtn)
        
        popupNode.isHidden =  true
        popupBackground.isHidden = true
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
        
        
        if (frontTouchedNode.name == "attackButton")  {
            //            popupBackground.isHidden = false
            //            popupNode.isHidden = false
            attackPopup = AttackPopup(castleNames: MultipeerController.shared.otherCastles.map({ (castle) -> String in
                castle.name
            }), scene: self)
            self.addChild(attackPopup!)
        } else if popupBackground.contains(location) && !popupNode.contains(location) {
            //                popupNode.isHidden = true
            //               popupBackground.isHidden = true
            attackPopup?.removeFromParent()
            attackPopup = nil
        }
        if (frontTouchedNode.name == "plusTroop") {
            army += 1
        } else if (frontTouchedNode.name == "minusTroop" && army > 0) {
            army -= 1
        }
        soldiersAmountLabel.text = "\(army)"
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if (soldierInstance.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.soldierInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (farmerInstance.contains(location) && gameController.castle.villager >= multiplierSelected && gameController.farmerInQueue < 4 && gameController.castle.farmer <= 5) {
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
