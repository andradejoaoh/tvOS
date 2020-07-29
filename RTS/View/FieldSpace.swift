//
//  FieldSpace.swift
//  RTS
//
//  Created by Alex Nascimento on 28/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit

class FieldSpace {
    
    unowned var emptyFieldNode: SKSpriteNode
    unowned var farmNode: SKSpriteNode
    unowned var triggerBox: SKShapeNode
    unowned var castle: Castle
    unowned var gameScene: GameScene
    var isFarmEnabled: Bool {
        didSet {
            if isFarmEnabled {
                emptyFieldNode.isHidden = true
                farmNode.isHidden = false
            } else {
                emptyFieldNode.isHidden = false
                farmNode.isHidden = true
            }
        }
    }
    var workingBuilders = 0
    var farmCompletion: Double = 0
    var workingFarmers = 0
    static let buildingRate: Double = 5
    private var createFarmerIsRunning: Bool = false
    var farmerInQueue: Int = 0 {
        didSet{
            if createFarmerIsRunning == false {
                createFarmer()
            }
        }
    }
    
    init(emptyField: SKSpriteNode, farm: SKSpriteNode, trigger: SKShapeNode, _ farmEnabled: Bool, castle: Castle, gameScene: GameScene) {
        self.emptyFieldNode = emptyField
        self.farmNode = farm
        self.triggerBox = trigger
        self.isFarmEnabled = farmEnabled
        self.castle = castle
        self.gameScene = gameScene
    }
    
    private func createFarmer(){
        self.createFarmerIsRunning = true
        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(Farmer.timeToMake), repeats: false) { (timer) in
            self.farmerInQueue -= 1
            self.castle.farmer += 1
            self.createFarmerIsRunning = false
            self.gameScene.updateLabel()
            if self.farmerInQueue == 0 {
                timer.invalidate()
            } else if self.farmerInQueue > 0 {
                self.createFarmer()
            }
        }
    }
    
    func finishBuildingFarm() {
        workingFarmers = workingBuilders
        workingBuilders = 0
        isFarmEnabled = true
    }
    
    func destroyFarm() {
        isFarmEnabled = false
        workingFarmers = 0
        farmCompletion = 0
    }
}
