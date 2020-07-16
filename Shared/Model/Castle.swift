//
//  Castle.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//


import Foundation

 class Castle {
    //Player name.
    let name: String
    
    //City names
    static var citynames: [String] = ["Rodes","Carcassone","Rothenburg","San Gimignano","Chester","Colmar","Ávila"]
    
    //Castle life.
    var life: Int = 6000
    
    //Villagers amount.
    var villager: Int = 50
    
    //Soldiers amount.
    var soldier: Int = 0
    
    //Farmers amount.
    var farmer: Int = 0
    
    //Archers amount.
    var archer: Int = 0
    
    static func getUniqueName() -> String {
        if citynames.count > 0 {
        return citynames.remove(at: Int.random(in: 0...citynames.count - 1))
        } else {
            fatalError("City not found")
        }
    }
    
    init() {
        name = Castle.getUniqueName()
    }
}
