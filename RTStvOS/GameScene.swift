//
//  GameScene.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 14/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    weak var gameView: GameView?
    lazy var gameController: GameController = GameController(gameScene: self)
    private var backgroudNode: SKSpriteNode = SKSpriteNode(imageNamed: "overWorld")
    
    private var castleNodes: [SKSpriteNode] = []

    private var soldierWalkTextures: [SKTexture] = []
    private var soldierAttackTextures: [SKTexture] = []
    private var castleList: [Castle] = []
    
    override func sceneDidLoad() {
        print("[TV] GameScene: sceneDidLoad")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
        buildSoldier()
    }
    
    override func didMove(to view: SKView) {
        self.addChild(backgroudNode)
        updateCastleList()
        createMap(castleList: castleList)
        checkArchersAndHP()
    }
    
    func createMap(castleList: [Castle]) {
        var posX: CGFloat = 0
        
        for castle in 0..<castleList.count {
            
            let posY: CGFloat = self.frame.height/3 - CGFloat(castle%2) * self.frame.height/2.2
            let frameX = self.frame.width * 0.7 / CGFloat(castleList.count-1) * CGFloat(castle)
            posX = frameX - self.frame.width * 0.35
            
            let castleNode = SKSpriteNode(imageNamed: "castle")
            castleNode.size = CGSize(width: self.frame.width/6, height: self.frame.height/4)
            castleNode.position = CGPoint(x: posX, y: posY)
            castleNode.zPosition = 2
            castleNode.name = castleList[castle].name
            
            let castleLabel = iOSLabelNode(fontSize: 40, fontColor: .black, text: castleList[castle].name)
            castleLabel.position.y += 60
            castleNode.addChild(castleLabel)
            
            self.addChild(castleNode)
            self.castleNodes.append(castleNode)
        }
    }
    
    func setupNodes(){
        backgroudNode.size = CGSize(width: self.frame.width, height: self.frame.height)

    }
    
    func attackAnimation(army: Army ,from: Castle, to: Castle){
        let soldier: SKSpriteNode = SKSpriteNode(imageNamed: "soldierWalk0")
        soldier.size = CGSize(width: self.frame.width/12, height: self.frame.height/6)
        soldier.zPosition = 2
        
        let soldierLabel = iOSLabelNode(fontSize: 40, fontColor: .black, text: "\(army.soldierCount)")
        soldierLabel.position.y += 60
        
        soldier.addChild(soldierLabel)
        
        guard let fromNode = castleNodes.first(where: { (aCastleNode) -> Bool in
            aCastleNode.name == from.name
        }) else { return }
        
        guard let toNode = castleNodes.first(where: { (aCastleNode) -> Bool in
            aCastleNode.name == to.name
        }) else { return }
        
        let fromPosition: CGPoint = fromNode.position
        let toPosition: CGPoint = toNode.position
        
        soldier.position = fromPosition
        var movePos: CGPoint = toPosition
        
        if fromPosition.x > toPosition.x {
            soldier.xScale = -1
            movePos.x += 60
        } else {
            soldier.xScale = 1
            movePos.x -= 60
        }
        
        if fromPosition.y > toPosition.y {
            movePos.y += 60
        } else {
            movePos.y -= 60
        }
        
        let distance = CGPoint.CGPointDistance(from: fromPosition, to: toPosition)
        let animationTime = Double(distance/70)
        
        
        let soldierMove = SKAction.move(to: movePos, duration: animationTime)
        let soldierSprite = SKAction.animate(with: soldierWalkTextures, timePerFrame: 0.25)
        let soldierWalk = SKAction.repeat(soldierSprite, count: Int(ceil(animationTime)))
        
        let soldierWalkAnimation = SKAction.group([soldierMove, soldierWalk])
        
        self.addChild(soldier)
        
        soldier.run(soldierWalkAnimation) {
            let soldierAttack = SKAction.animate(with: self.soldierAttackTextures, timePerFrame: 0.2)
            let soldierAttackAnimation = SKAction.repeatForever(soldierAttack)
                
            
            soldier.run(soldierAttackAnimation)
            
            self.beginAttack(attackerArmy: army, armyLabel: soldierLabel, defensorCastle: to, completion: {
                soldier.removeFromParent()
            })

        }
    }

    
    func buildSoldier() {
        let soldierWalkAtlas = SKTextureAtlas(named: "soldierWalk")
        let soldierAttackAtlas = SKTextureAtlas(named: "soldierAttack")

        let numWalkImages = soldierWalkAtlas.textureNames.count
        let numAttackImages = soldierAttackAtlas.textureNames.count

        for i in 0..<numWalkImages {
            let soldierTextureName = "soldierWalk\(i)"
            soldierWalkTextures.append(soldierWalkAtlas.textureNamed(soldierTextureName))
        }
        
        for i in 0..<numAttackImages {
            let soldierTextureName = "soldierAttack\(i)"
            soldierAttackTextures.append(soldierAttackAtlas.textureNamed(soldierTextureName))
        }
    }
    
    func beginAttack(attackerArmy: Army, armyLabel: SKLabelNode, defensorCastle: Castle, completion: @escaping () -> Void){
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if attackerArmy.soldierCount > 0 && defensorCastle.hp > 0 {
                defensorCastle.receiveAttack(damage: attackerArmy.attack())
                attackerArmy.receiveDamage(damage: defensorCastle.defensorAttack())
                armyLabel.text = "\(attackerArmy.soldierCount)"
                self.updateCastleList()
                self.checkArchersAndHP()
                self.checkIfSomeoneWon()
                self.beginAttack(attackerArmy: attackerArmy, armyLabel: armyLabel, defensorCastle: defensorCastle, completion: completion)
            } else {
                completion()
                return
            }
        }
    }
    
    func checkIfSomeoneWon() {
        var playersAlive = [Player]()
        MultipeerController.shared.players.forEach { (player) in
            if player.castle.hp > 0 {
                playersAlive.append(player)
            }
        }
        if playersAlive.count <= 1 {
            if playersAlive.count == 1 {
                let id = playersAlive.first!.id
                guard let data = "youWon".data(using: .utf8) else { return }
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [id])
                let popupNode = SKSpriteNode(color: .gray, size: CGSize(width: 400, height: 400))
                let popupLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "\(playersAlive.first!.castle.name) won!")
                popupNode.addChild(popupLabel)
                addChild(popupNode)
            } else  {
                guard let data = "draw".data(using: .utf8) else { return }
                MultipeerController.shared.sendToAllPeers(data, reliably: true)
                let popupNode = SKSpriteNode(color: .gray, size: CGSize(width: 400, height: 400))
                let popupLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "It's a draw!")
                popupNode.addChild(popupLabel)
                addChild(popupNode)
            }
            guard let data = "goBackToLobby".data(using: .utf8) else { return }
            MultipeerController.shared.sendToAllPeers(data, reliably: true)
            _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) {_ in 
                self.gameView?.goToLobby()
            }
        }
    }
    func checkArchersAndHP(){
        for castle in castleList {
            let archerNode = iOSLabelNode(fontSize: 40, fontColor: .black, text: "\(castle.archer)")
            let hpNode = iOSLabelNode(fontSize: 40, fontColor: .black, text:  "\(castle.hp)")
            
            hpNode.name = "hpNode"
            hpNode.position.y -= 60
            
            archerNode.name = "archerNode"
            archerNode.position.y -= 100
            
            guard let castleNode = castleNodes.first(where: {$0.name == castle.name }) else { return }
            var removeNodes: [SKNode] = []
            
            if let hpRemove = castleNode.childNode(withName: "hpNode"),
            let archerRemove = castleNode.childNode(withName: "archerNode") {
                removeNodes.append(hpRemove)
                removeNodes.append(archerRemove)
            }
            castleNode.removeChildren(in: removeNodes)
            
            castleNode.addChild(hpNode)
            castleNode.addChild(archerNode)
        }
    }
    
    func updateCastleList(){
        castleList.removeAll()
        castleList = MultipeerController.shared.players.map({ (player) -> Castle in
            let newCastle = player.castle
            MultipeerController.shared.castles.append(newCastle)
            return newCastle
        })
    }
}
