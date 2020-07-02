//
//  Soldier.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation

public struct Soldier {
    //Soldier life.
    let hp: Int = 30
    
    //Attack damage per attack.
    let attack: Int = 5
    
    //Time to make the soldier in seconds.
    let timeToMake: Int = 2
    
    //Price to make the soldier.
    static let price: Int = 5
}
