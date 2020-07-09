//
//  ViewController.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit
import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    let gameScene: SKScene = SKScene()
    let gameView: SKView = SKView()
    var castle: Castle = Castle()
    var createSoldierIsRunning: Bool = false
    var trainningInstance = SKSpriteNode()
    var soldiersInQueue: Int = 0 {
        didSet{
            if createSoldierIsRunning == false{
                createSoldier()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainningInstance.size = CGSize(width: 1, height: 1)
        trainningInstance.color = SKColor.black
        
        if let view = self.view as! SKView? {
            gameScene.scaleMode = .aspectFill
            gameScene.backgroundColor = SKColor.red
            gameScene.addChild(trainningInstance)

            view.presentScene(gameScene)
        }
    }
    
    
    func createSoldierButton(_ sender: Any) {
        soldiersInQueue += 1
    }
    
    func updateLabels(){
        //        resourcesLabel.text = "Resources: \(castle.coins)"
        //        soldiersLabel.text = "Soldiers: \(castle.soldiers)"
    }
    
    
    func createSoldier(){
        self.createSoldierIsRunning = true
        castle.coins -= Soldier.price
        soldiersInQueue -= 1
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.castle.soldiers += 1
            self.updateLabels()
            self.createSoldierIsRunning = false
            
            if self.soldiersInQueue == 0 {
                timer.invalidate()
            } else if self.soldiersInQueue > 0 {
                self.createSoldier()
            }
        }
    }
    
}

extension ViewController: MultipeerHandler {
    
    func peerDiscovered(_ id: MCPeerID) -> Bool {
        return true
    }
    
    func peerLost(_ id: MCPeerID) {
            print("Lost connection")
    }
    
    
}

