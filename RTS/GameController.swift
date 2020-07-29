//
//  GameController.swift
//  RTS
//
//  Created by João Henrique Andrade on 06/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameController {
    
    var castle: Castle = {
        #if OFFLINE
        return Castle()
        #else
        guard let castle = MultipeerController.shared.myCastle else { fatalError("myCastle not found") }
        return castle
        #endif
        
    }()
    unowned var gameScene: GameScene
    
    private var createSoldierIsRunning: Bool = false
    var soldierInQueue: Int = 0 {
        didSet{
            if createSoldierIsRunning == false{
                createSoldier()
            }
        }
    }
    
    private var createArcherIsRunning: Bool = false
    var archerInQueue: Int = 0 {
        didSet{
            if createArcherIsRunning == false{
                createArcher()
            }
        }
    }
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        setupFarmerTimer()
    }
    
    private func createSoldier(){
        self.createSoldierIsRunning = true
        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(Soldier.timeToMake), repeats: false) { (timer) in
            self.soldierInQueue -= 1
            self.castle.soldier += 1
            self.createSoldierIsRunning = false
            self.gameScene.updateLabel()
            if self.soldierInQueue == 0 {
                timer.invalidate()
            } else if self.soldierInQueue > 0 {
                self.createSoldier()
            }
        }
    }
    
    private func createArcher(){
        self.createArcherIsRunning = true
        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(Archer.timeToMake), repeats: false) { (timer) in
            self.archerInQueue -= 1
            self.castle.archer += 1
            self.createArcherIsRunning = false
            self.gameScene.updateLabel()
            MultipeerController.shared.sendToHost(msg: "addArcher:\(1)_\(self.castle.name)")
            if self.archerInQueue == 0 {
                timer.invalidate()
            } else if self.archerInQueue > 0 {
                self.createArcher()
            }
        }
    }
    
    @objc private func farmerResources(){
        let resourcesPerTick = Int(castle.farmer/2)
        castle.villager += resourcesPerTick
        gameScene.updateLabel()
    }
    
    private func setupFarmerTimer(){
        let _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.farmerResources), userInfo: nil, repeats: true)
    }
}
