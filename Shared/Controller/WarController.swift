////
////  WarController.swift
////  RTS
////
////  Created by João Henrique Andrade on 08/07/20.
////  Copyright © 2020 João Henrique Andrade. All rights reserved.
////
//
//import Foundation
//class WarController {
//
//    func attackCastle(soldierCount:Int, defensorCastle: Castle, attackerCastle: Castle) -> Castle {
//        var soldierCount = soldierCount
//        let defensorCastle = defensorCastle
//        var overDefenseDamage = 0
//        var overAttackDamage = 0
//
//        while (soldierCount > 0 && defensorCastle.life > 0){
//            let defensorDamage = defensorCastle.archer * Archer.attack + overDefenseDamage
//            let soldiersKilled = Int(defensorDamage/Soldier.hp)
//            overDefenseDamage = (defensorDamage - overDefenseDamage) % Soldier.hp
//
//            let attackerDamage = soldierCount * Soldier.attack + overAttackDamage
//            let archersKilled = Int(attackerDamage/Archer.hp)
//            overAttackDamage = (attackerDamage - overAttackDamage) % Archer.hp
//
//
//            if soldierCount >= soldiersKilled {
//                soldierCount -= soldiersKilled
//            } else if soldiersKilled > soldierCount {
//                soldierCount = 0
//                //TODO: Atacantes perderam a batalha
//                return defensorCastle
//            }
//
//
//            if defensorCastle.archer >= archersKilled {
//                defensorCastle.archer -= archersKilled
//
//            } else if defensorCastle.life > attackerDamage {
//                defensorCastle.archer = 0
//                defensorCastle.life -= attackerDamage
//            } else {
//                defensorCastle.life = 0
//                //TODO: Defensores perderam a batalha
//                return attackerCastle
//            }
//        }
//        return attackerCastle
//    }
//
//    func archerDamage(archerCount: Int, castle: Castle) -> Int{
//        return castle.archer * Archer.attack
//    }
//
//}
