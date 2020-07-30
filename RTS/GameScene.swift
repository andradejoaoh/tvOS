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
    let MAX_FARMERS = 5
    let MAX_BUILDERS = 3
    
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
        FieldSpace(emptyField: self.field1Sprite, farm: self.farm1Sprite, trigger: self.farm1Trigger, true, castle: self.gameController.castle, gameScene: self)
    }()
    private lazy var fieldSpace2: FieldSpace = {
        FieldSpace(emptyField: self.field2Sprite, farm: self.farm2Sprite, trigger: self.farm2Trigger, false, castle: self.gameController.castle, gameScene: self)
    }()
    private lazy var fieldSpace3: FieldSpace = {
        FieldSpace(emptyField: self.field3Sprite, farm: self.farm3Sprite, trigger: self.farm3Trigger, false, castle: self.gameController.castle, gameScene: self)
    }()
    private lazy var fieldSpace4: FieldSpace = {
        FieldSpace(emptyField: self.field4Sprite, farm: self.farm4Sprite, trigger: self.farm4Trigger, false, castle: self.gameController.castle, gameScene: self)
    }()
    
    // HUD (labels and buttons)
    private var attackButton = SKSpriteNode(texture: SKTexture(imageNamed: "attackButton"), size: CGSize(width: 80, height: 80))
    private var soldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Soldiers")
    private var farmersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Farmers")
    private var villagersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Villagers")
    private var archersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "Archers")
    private var hpLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "6000/6000")
    
    private var soldierIcon = iOSIconNode(imageNamed: "soldierIcon")
    private var archerIcon = iOSIconNode(imageNamed: "archerIcon")
    private var farmerIcon = iOSIconNode(imageNamed: "farmerIcon")
    private var villagerIcon = iOSIconNode(imageNamed: "villagerIcon")
    private var hpIcon = iOSIconNode(imageNamed: "hpIcon")
    
    private var trainingSoldiersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "")
    private var trainingArchersLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "")
    
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
        self.addChild(hpLabel)
        
        self.addChild(soldierIcon)
        self.addChild(archerIcon)
        self.addChild(farmerIcon)
        self.addChild(hpIcon)
        self.addChild(villagerIcon)
        
        self.addChild(attackButton)
        self.addChild(castleTrigger)
        self.addChild(barracksTrigger)
        self.addChild(farm1Trigger)
        self.addChild(farm2Trigger)
        self.addChild(farm3Trigger)
        self.addChild(farm4Trigger)
        self.addChild(trainingSoldiersLabel)
        self.addChild(trainingArchersLabel)


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
    
    var lastTime: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastTime
        // update farm completion for farms that are not already built
        for f in [fieldSpace1, fieldSpace2, fieldSpace3, fieldSpace4].filter({ (fs) -> Bool in
            !fs.isFarmEnabled
        }) {
            f.farmCompletion += Double(f.workingBuilders) * FieldSpace.buildingRate * deltaTime
            if f.farmCompletion >= 100 {
                f.finishBuildingFarm()
            }
        }
        lastTime = currentTime
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

//        multiplierNode.position.x = CGFloat(screenSize.width/2 - multiplierNode.frame.width/2)
//        multiplierNode.position.y += self.frame.height/2 - 80
//        multiplierNode.addChild(multiplierLabel)
//        multiplierNode.zPosition = 2
//        multiplierLabel.zPosition = 3
        
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
        soldierIcon.position.y = soldiersLabel.position.y
        soldierIcon.position.x -= 50
        
        farmersLabel.position.y = soldiersLabel.position.y
        farmerIcon.position.x = -self.frame.width/2 + 100
        farmerIcon.position.y = farmersLabel.position.y
        farmersLabel.position.x = farmerIcon.position.x + 50

        villagersLabel.position.y += self.frame.height/2 - 160
        villagersLabel.position.x = -self.frame.width/5
        villagerIcon.position.y = villagersLabel.position.y
        villagerIcon.position.x = villagersLabel.position.x - 50
        
        archersLabel.position.y = soldiersLabel.position.y
        archersLabel.position.x += self.frame.width/2 - 100
        archerIcon.position.y = archersLabel.position.y
        archerIcon.position.x = archersLabel.position.x - 50

        hpLabel.position.y += self.frame.height/2 - 160
        hpLabel.position.x = self.frame.width/5
        hpIcon.position.y = hpLabel.position.y
        hpIcon.position.x = hpLabel.position.x - 120

        attackButton.position.y = -screenSize.height/2 + 120
        attackButton.zPosition = 13
        
        backgroundNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        updateLabel()
        trainingSoldiers()
        trainingArchers()
    }
    
    func addLayerNode(_ node: SKSpriteNode, _ zPos: CGFloat = 5) {
        node.size = CGSize(width: self.frame.width, height: self.frame.height)
        node.zPosition = zPos
        addChild(node)
    }
    
    func updateLabel(){
        soldiersLabel.text = "\(gameController.castle.soldier)"
        villagersLabel.text = "\(gameController.castle.villager)"
        farmersLabel.text = "\(gameController.castle.farmer)"
        archersLabel.text = "\(gameController.castle.archer)"
        hpLabel.text = "\(gameController.castle.hp)/6000"
        trainingArchers()
        trainingSoldiers()
        
//        multiplierLabel.text = "\(multiplierSelected)x"
//
//        if multiplierSelected > gameController.castle.villager {
//            multiplierNode.color = UIColor.gray
//        } else {
//            multiplierNode.color = UIColor.green
//        }
    }
    
    func trainingSoldiers () {
        let trainingSoldiers = gameController.soldierInQueue
        trainingSoldiersLabel.position.x  = self.frame.midX + self.frame.width/9
        trainingSoldiersLabel.position.y = self.frame.minY + self.frame.height/4.15
        trainingSoldiersLabel.zPosition = 11
        trainingSoldiersLabel.text = "\(trainingSoldiers)"
        setupCircle(x: self.frame.midX + self.frame.width/9, y: self.frame.minY + self.frame.height/4)
    }
    
    func trainingArchers() {
        let trainingArchers = gameController.archerInQueue 
        trainingArchersLabel.position.x  = self.frame.midX + self.frame.width/8.5
        trainingArchersLabel.position.y = self.frame.midY + self.frame.height/7.5
        trainingArchersLabel.zPosition = 11
        trainingArchersLabel.text = "\(trainingArchers)"
        setupCircle(x: self.frame.midX + self.frame.width/8.5, y: self.frame.midY + self.frame.height/7)
    }
    
    func setupCircle (x: CGFloat, y: CGFloat) {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: x, y: y),
                    radius: 30,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        let ball = SKShapeNode(path: path)
        ball.lineWidth = 1
        ball.fillColor = .lightGray
        ball.strokeColor = .white
        ball.glowWidth = 0.5
        ball.zPosition = 10
        self.addChild(ball)
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
            } else if (farm1Trigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                if (fieldSpace1.isFarmEnabled && fieldSpace1.farmerInQueue + fieldSpace1.workingFarmers + multiplierSelected <= MAX_FARMERS) {
                    fieldSpace1.farmerInQueue += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                } else if (!fieldSpace1.isFarmEnabled  && fieldSpace1.workingBuilders + multiplierSelected <= MAX_BUILDERS) {
                    fieldSpace1.workingBuilders += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                }
            } else if (farm2Trigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
            if (fieldSpace2.isFarmEnabled && fieldSpace2.farmerInQueue + fieldSpace2.workingFarmers + multiplierSelected <= MAX_FARMERS) {
                fieldSpace2.farmerInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            } else if (!fieldSpace2.isFarmEnabled  && fieldSpace2.workingBuilders + multiplierSelected <= MAX_BUILDERS) {
                fieldSpace2.workingBuilders += multiplierSelected
                gameController.castle.villager -= multiplierSelected
                }
            } else if (farm3Trigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                if (fieldSpace3.isFarmEnabled && fieldSpace3.farmerInQueue + fieldSpace3.workingFarmers + multiplierSelected <= MAX_FARMERS) {
                    fieldSpace3.farmerInQueue += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                } else if (!fieldSpace3.isFarmEnabled  && fieldSpace3.workingBuilders + multiplierSelected <= MAX_BUILDERS) {
                    fieldSpace3.workingBuilders += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                }
            } else if (farm4Trigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                if (fieldSpace4.isFarmEnabled && fieldSpace4.farmerInQueue + fieldSpace4.workingFarmers + multiplierSelected <= MAX_FARMERS) {
                    fieldSpace4.farmerInQueue += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                } else if (!fieldSpace4.isFarmEnabled  && fieldSpace4.workingBuilders + multiplierSelected <= MAX_BUILDERS) {
                    fieldSpace4.workingBuilders += multiplierSelected
                    gameController.castle.villager -= multiplierSelected
                }
            } else if (castleTrigger.contains(location) && gameController.castle.villager >= multiplierSelected) {
                gameController.archerInQueue += multiplierSelected
                gameController.castle.villager -= multiplierSelected
            }
//            else if multiplierNode.contains(location){
//                switch multiplierSelected {
//                case 1:
//                    multiplierSelected = 5
//                case 5:
//                    multiplierSelected = 10
//                case 10:
//                    multiplierSelected = 20
//                case 20:
//                    multiplierSelected = 50
//                default:
//                    multiplierSelected = 1
//                }
//            }
            #if TEST_VICTORY_CONDITIONS
            if testGameOver.contains(location) {
                gameOver()
            } else if testGameWon.contains(location) {
                gameWon()
            }
            #endif
            updateLabel()
            trainingSoldiers()
            trainingArchers()
        }
    }
    
    func processFarmDamage(totalDmg: Int) {
        for f in [fieldSpace1, fieldSpace2, fieldSpace3, fieldSpace4] {
            if f.isFarmEnabled {
                f.takeHit(dmg: totalDmg)
                break
            }
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
