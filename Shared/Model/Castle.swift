//
//  Castle.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//


import Foundation

public class Castle {
    //Player name.
    let name: String
    
    //City names
    static var citynames: [String] = ["Rodes","Carcassone","Rothenburg","San Gimignano","Chester","Colmar","Ávila"]
    
    //Castle life.
    var hp: Int = 6000
    
    //Villagers amount.
    var villager: Int = 50
    
    //Soldiers amount.
    var soldier: Int = 0
    
    //Farmers amount.
    var farmer: Int = 0
    
    //Archers amount.
    var archer: Int = 0
    
    private var overReceivedDamage: Int = 0
    
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
    
    init(named: String) {
        self.name = named
    }
    
    func defensorAttack() -> Int {
        return archer * Archer.attack
    }
    
#if os(tvOS)
    private func receiveDamage(damage: Int){
        if self.hp > (damage + overReceivedDamage) {
            self.hp -= damage + overReceivedDamage
        } else {
            self.hp = 0
            print("Castelo \(self.name) Morreu - WASTED!")
            
            
        }
    }
    
    func receiveAttack(damage: Int){
        let receivedDamage = damage + overReceivedDamage
        let deadArchers = (damage + overReceivedDamage)/Archer.hp
        overReceivedDamage = damage % Archer.hp
        archer -= deadArchers
        
        print("Castle HP: \(self.hp)")
        print("Dano recebido: \(receivedDamage)")
        
        if archer > 0 {
            if (archer > deadArchers){
                archer -= deadArchers
            } else {
                let archerHP = archer * Archer.hp
                archer = 0
                self.receiveDamage(damage: receivedDamage - archerHP)
            }
        } else {
            self.receiveDamage(damage: receivedDamage)
        }
        
        if let player = MultipeerController.shared.players.first { (player) -> Bool in
            player.castle.name == self.name
            } {
            guard let data = "updateCastle:\(self.hp)_\(self.archer)".data(using: .utf8) else { return }
            MultipeerController.shared.sendToPeers(data, reliably: true, peers: [player.id])
        }
        
    }
#endif
}
