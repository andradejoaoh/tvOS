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

let showTriggers: Bool = {
    #if SHOW_TRIGGERS
    return true
    #else
    return false
    #endif
}()

class GameScene: SKScene {
    lazy var gameController: GameController = GameController(gameScene: self)
    lazy var screenSize = self.frame
    
    // Sprites
    private let backgroundNode = SKSpriteNode(imageNamed: "city_background.png")
    private let farm1Sprite = SKSpriteNode(imageNamed: "city_farm1.png")
    private let farm2Sprite = SKSpriteNode(imageNamed: "city_farm2.png")
    private let farm3Sprite = SKSpriteNode(imageNamed: "city_farm3.png")
    private let farm4Sprite = SKSpriteNode(imageNamed: "city_farm4.png")
    private let field1Sprite = SKSpriteNode(imageNamed: "city_field1.png")
    private let field2Sprite = SKSpriteNode(imageNamed: "city_field2.png")
    private let field3Sprite = SKSpriteNode(imageNamed: "city_field3.png")
    private let field4Sprite = SKSpriteNode(imageNamed: "city_field4.png")
    private let castleSprite = SKSpriteNode(imageNamed: "city_castle.png")
    private let barracksSprite = SKSpriteNode(imageNamed: "city_barracks.png")
    
    // Trigger Boxes
    private lazy var farm1Trigger: SKShapeNode = {
        let topleft = CGPoint(x: self.frame.minX, y: self.frame.minY + self.frame.height/5)
        let topRight = CGPoint(x: self.frame.midX + self.frame.width/20, y: self.frame.minY + self.frame.height/8.5)
        let bottomRight = CGPoint(x: self.frame.midX, y: self.frame.minY)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY)
        let color = !showTriggers ? .clear : UIColor.init(red: 1.0, green: 0.1, blue: 0.4, alpha: 0.3)
        return makeShapeNode([topleft, topRight, bottomRight, bottomLeft], color)
    }()
    private lazy var farm2Trigger: SKShapeNode = {
        let topleft = CGPoint(x: self.frame.minX, y: self.frame.minY + self.frame.height/3.7)
        let topRight = CGPoint(x: self.frame.midX - self.frame.width/20, y: self.frame.minY + self.frame.height/3)
        let bottomRight = CGPoint(x: self.frame.midX + self.frame.width/20, y: self.frame.minY + self.frame.height/8.5)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY + self.frame.height/5)
        let color = !showTriggers ? .clear : UIColor.init(red: 0.1, green: 1.0, blue: 0.4, alpha: 0.3)
        return makeShapeNode([topleft, topRight, bottomRight, bottomLeft], color)
    }()
    private lazy var farm3Trigger: SKShapeNode = {
        let topleft = CGPoint(x: self.frame.minX, y: self.frame.midY - self.frame.height/20)
        let topRight = CGPoint(x: self.frame.midX - self.frame.width/7, y: self.frame.midY - self.frame.height/9.5)
        let bottomRight = CGPoint(x: self.frame.midX - self.frame.width/20, y: self.frame.minY + self.frame.height/3)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.minY + self.frame.height/3.7)
        let color = !showTriggers ? .clear : UIColor.init(red: 0.1, green: 0.4, blue: 1.0, alpha: 0.3)
        return makeShapeNode([topleft, topRight, bottomRight, bottomLeft], color)
    }()
    private lazy var farm4Trigger: SKShapeNode = {
        let topleft = CGPoint(x: self.frame.minX + self.frame.width/9, y: self.frame.midY)
        let topRight = CGPoint(x: self.frame.midX - self.frame.width/13, y: self.frame.midY - self.frame.height/80)
        let bottomRight = CGPoint(x: self.frame.midX - self.frame.width/7, y: self.frame.midY - self.frame.height/9.5)
        let bottomLeft = CGPoint(x: self.frame.minX, y: self.frame.midY - self.frame.height/20)
        let color = !showTriggers ? .clear : UIColor.init(red: 1.0, green: 0.4, blue: 0.1, alpha: 0.3)
        return makeShapeNode([topleft, topRight, bottomRight, bottomLeft], color)
    }()
    private lazy var castleTrigger: SKShapeNode = {
        let rect = CGRect(x: self.frame.midX,
                          y: self.frame.midY + self.frame.height/5.5,
                          width: self.frame.width/2,
                          height: -self.frame.height/3)
        let shapeNode = SKShapeNode(rect: rect)
        shapeNode.zPosition = 20
        shapeNode.fillColor = !showTriggers ? .clear : UIColor.init(red: 1.0, green: 0.4, blue: 0.1, alpha: 0.3)
        shapeNode.lineWidth = 0
        return shapeNode
    }()
    private lazy var barracksTrigger: SKShapeNode = {
        let rect = CGRect(x: self.frame.midX + self.frame.width/10,
                          y: self.frame.minY + self.frame.height/5.5,
                          width: self.frame.width/2.6,
                          height: self.frame.height/6.5)
        let shapeNode = SKShapeNode(rect: rect)
        shapeNode.zPosition = 20
        shapeNode.fillColor = !showTriggers ? .clear : UIColor.init(red: 0.8, green: 0.8, blue: 0.1, alpha: 0.3)
        shapeNode.lineWidth = 0
        return shapeNode
    }()
    
    // Field Spaces
    private lazy var fieldSpace1: FieldSpace = {
        FieldSpace(emptyField: self.field1Sprite, farm: self.farm1Sprite, trigger: self.farm1Trigger, true)
    }()
    private lazy var fieldSpace2: FieldSpace = {
        FieldSpace(emptyField: self.field2Sprite, farm: self.farm2Sprite, trigger: self.farm2Trigger, false)
    }()
    private lazy var fieldSpace3: FieldSpace = {
        FieldSpace(emptyField: self.field3Sprite, farm: self.farm3Sprite, trigger: self.farm3Trigger, false)
    }()
    private lazy var fieldSpace4: FieldSpace = {
        FieldSpace(emptyField: self.field4Sprite, farm: self.farm4Sprite, trigger: self.farm4Trigger, false)
    }()
    
    // HUD (labels and buttons)
    private var attackButton = SKSpriteNode(texture: SKTexture(imageNamed: "attackButton"), size: CGSize(width: 80, height: 80))
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
        self.addChild(attackButton)
        self.addChild(castleTrigger)
        self.addChild(barracksTrigger)
        self.addChild(farm1Trigger)
        self.addChild(farm2Trigger)
        self.addChild(farm3Trigger)
        self.addChild(farm4Trigger)

        #if TEST_VICTORY_CONDITIONS
        // test
        self.addChild(testGameWon)
        self.addChild(testGameOver)
        #endif
    }
    
    override func sceneDidLoad() {
        print("[iOS] GameScene: sceneDidLoad. size: \(self.size)")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
    }
    
    func setupNodes(){
        
        addLayerNode(farm1Sprite, 9)
        addLayerNode(farm2Sprite, 8)
        addLayerNode(farm3Sprite, 7)
        addLayerNode(farm4Sprite, 6)
        addLayerNode(field1Sprite, 9)
        addLayerNode(field2Sprite, 8)
        addLayerNode(field3Sprite, 7)
        addLayerNode(field4Sprite, 6)
        addLayerNode(castleSprite)
        addLayerNode(barracksSprite, 8)
        
        fieldSpace1.isFarmEnabled = true
        fieldSpace2.isFarmEnabled = false
        fieldSpace3.isFarmEnabled = false
        fieldSpace4.isFarmEnabled = false

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
        attackButton.zPosition = 50
        
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        updateLabel()
    }
    
    func addLayerNode(_ node: SKSpriteNode, _ zPos: CGFloat = 5) {
        node.size = CGSize(width: self.frame.width, height: self.frame.height)
        node.zPosition = zPos
        addChild(node)
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
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if (barracksTrigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.soldierInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (farm1Trigger.contains(location) && gameController.castle.villager >= multiplierSelected && gameController.farmerInQueue + gameController.castle.farmer < 5) {
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
    
    private func makeShapeNode(_ vertices: [CGPoint], _ color: UIColor = .clear, _ zPos: CGFloat = 20) -> SKShapeNode {
        let path = CGMutablePath()
        path.move(to: vertices[0])
        path.addLines(between: vertices)
        let shapeNode = SKShapeNode(path: path)
        shapeNode.fillColor = color
        shapeNode.zPosition = zPos
        shapeNode.lineWidth = 0
        return shapeNode
    }
}
