//
//  Army.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 20/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
class Army {
    var soldierCount: Int
    var overReceivedDamage: Int = 0
    
    init(soldierCount: Int){
        self.soldierCount = soldierCount
    }

    func attack() -> Int{
        return soldierCount * Soldier.attack
    }
    
    func receiveDamage(damage: Int){
        let totalDamage = damage + overReceivedDamage
        print("totalDamage: \(totalDamage)")
        let deadSoldiers = totalDamage/Soldier.hp
        print("totalDamage: \(deadSoldiers)")
        overReceivedDamage = totalDamage - deadSoldiers*Soldier.hp
        soldierCount -= deadSoldiers
        print("soldierCount: \(soldierCount)")
    }
}
