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
    
    lazy var gameController: GameController = GameController(gameScene: self)
    private var backgroudNode: SKSpriteNode = SKSpriteNode(imageNamed: "overWorld")
    private var soldier: SKSpriteNode = SKSpriteNode(imageNamed: "soldierWalk0")

    private var castleNodes: [SKSpriteNode] = []
    private var soldierWalkTextures: [SKTexture] = []
    
    override func sceneDidLoad() {
        print("[TV] GameScene: sceneDidLoad")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
        createMap(playerCount: 6)
        buildSoldier()
    }
    
    override func didMove(to view: SKView) {
        self.addChild(backgroudNode)
    }
    
    func createMap(playerCount: Int) {
        var posX: CGFloat = 0
        
        for player in 0..<playerCount {
            let castleNode = SKSpriteNode(imageNamed: "castle")
            let posY: CGFloat = self.frame.height/3 - CGFloat(player%2) * self.frame.height/2.2
            let frameX = self.frame.width * 0.7 / CGFloat(playerCount-1) * CGFloat(player)
            
            posX = frameX - self.frame.width * 0.35
            

            
            castleNode.size = CGSize(width: self.frame.width/6, height: self.frame.height/4)
            castleNode.position = CGPoint(x: posX, y: posY)
            castleNode.zPosition = 2
            self.addChild(castleNode)
            self.castleNodes.append(castleNode)
        }
    }
    
    func setupNodes(){
        backgroudNode.size = CGSize(width: self.frame.width, height: self.frame.height)
        soldier.size = CGSize(width: self.frame.width/10, height: self.frame.height/5)
        soldier.zPosition = 2
    }
    
    func attackAnimation(from: SKSpriteNode, to: SKSpriteNode){
        self.soldier.position = from.position
        if from.position.x > to.position.x {
            soldier.xScale = -1
        } else {
            soldier.xScale = 1
        }
        let distance = CGPoint.CGPointDistance(from: from.position, to: to.position)
        let animationTime = Double(distance/70)
        
        let soldierMove = SKAction.move(to: to.position, duration: animationTime)
        let soldierSprite = SKAction.animate(with: soldierWalkTextures, timePerFrame: 0.25)
        let soldierWalk = SKAction.repeat(soldierSprite, count: Int(animationTime))
        
        let soldierAnimation = SKAction.group([soldierMove, soldierWalk])
        
        self.addChild(self.soldier)
        
        self.soldier.run(soldierAnimation) {
            print("Rodou")
            self.soldier.removeFromParent()
        }
    }
    
    
    func buildSoldier() {
        let soldierWalkAtlas = SKTextureAtlas(named: "soldierWalk")
        let numImages = soldierWalkAtlas.textureNames.count
        
        for i in 0..<numImages {
            let soldierTextureName = "soldierWalk\(i)"
            soldierWalkTextures.append(soldierWalkAtlas.textureNamed(soldierTextureName))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        attackAnimation(from: castleNodes[2], to: castleNodes[5])
    }
}
