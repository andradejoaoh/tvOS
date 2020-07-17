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
    private var castleNodes: [SKSpriteNode] = []
    
    override func sceneDidLoad() {
        print("[TV] GameScene: sceneDidLoad")
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .fill
        self.backgroundColor = SKColor.white
        setupNodes()
        createMap(playerCount: 4)
    }
    
    override func didMove(to view: SKView) {
        self.addChild(backgroudNode)
    }
    
    func createMap(playerCount: Int) {
        for player in 0...playerCount {
            let castleNode = SKSpriteNode(imageNamed: "castle")
            castleNode.size = CGSize(width: self.frame.width/6, height: self.frame.height/4)
            castleNode.position = CGPoint(x: self.frame.width/2 - CGFloat(player) * self.frame.width/5, y: self.frame.height/4 - CGFloat(player%2) * -self.frame.height/3)
            castleNode.zPosition = 2
            self.addChild(castleNode)
            self.castleNodes.append(castleNode)
        }
    }
    
    func setupNodes(){
        backgroudNode.size = CGSize(width: self.frame.width, height: self.frame.height)
    }
}
