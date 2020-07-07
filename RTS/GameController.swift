//
//  GameController.swift
//  RTS
//
//  Created by João Henrique Andrade on 06/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
class GameController {
    
    var castle: Castle = Castle()
    var createSoldierIsRunning: Bool = false
    var soldiersInQueue: Int = 0 {
        didSet{
            if createSoldierIsRunning == false{
                createSoldier()
            }
        }
    }
    
    func createSoldier(){
        self.createSoldierIsRunning = true
        castle.coins -= Soldier.price
        soldiersInQueue -= 1
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.castle.soldiers += 1
            self.createSoldierIsRunning = false
            
            if self.soldiersInQueue == 0 {
                timer.invalidate()
            } else if self.soldiersInQueue > 0 {
                self.createSoldier()
            }
        }
    }
}
