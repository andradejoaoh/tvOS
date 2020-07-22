//
//  GameView+MultipeerHandler.swift
//  RTStvOS
//
//  Created by Alex Nascimento on 17/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import MultipeerConnectivity

extension GameView: MultipeerHandler {
    
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        return false
    }
    
    func peerLeft(_ id: MCPeerID) {
        let player = MultipeerController.shared.players.first { (player) -> Bool in
            return player.id == id
        }
        player?.removePlayer()
    }
    
    func receivedData(_ data: Data, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let text = String(bytes: data, encoding: .utf8) else { return }
            var playerAux: Player?
            
            for index in 0..<MultipeerController.shared.players.count {
                if MultipeerController.shared.players[index].id == peerID {
                    playerAux = MultipeerController.shared.players[index]
                }
            }
            guard let player = playerAux else { return }
            
            let substrings = text.split(separator: ":")
            let funcName = substrings.first
            switch funcName {
            case "sendArmy":
                // "sendArmy:nSoldiers_fromCity_toCity"
                let parameters = substrings[1].split(separator: "_")
                guard let soldiers = Int(parameters[0]) else {return}
                let fromCity = String(parameters[1])
                let toCity = String (parameters[2])
                self.sendArmy(soldiers: soldiers, fromCity: fromCity, toCity: toCity)
            case "addArcher":
                let parameters = substrings[1].split(separator: "_")
                guard let archers = Int(parameters[0]) else {return}
                let onCity = String(parameters[1])
                self.addArcher(archers: archers, onCity: onCity)
            default:
                print ("[TV] GameView receivedData: No func found with name \(text) ")
            }
            MultipeerController.shared.sendToAllPeers(data, reliably: true)
        }
    }
    
    func sendArmy(soldiers: Int, fromCity: String, toCity: String) {
        let fromCastle = getCastle(named: fromCity)
        let toCastle = getCastle(named: toCity)
        if toCastle.hp > 0 {
            gameScene.attackAnimation(army: Army(soldierCount: soldiers), from: fromCastle, to: toCastle)
        }
    }
    
    func addArcher(archers: Int, onCity: String) {
       getCastle(named: onCity).archer += archers
    }
    
    func getCastle(named: String) -> Castle {
        for c in MultipeerController.shared.castles {
            if c.name == named {
                return c
            }
        }
        fatalError("getCastle: Didn't find castle with name \(named)\n")
    }
    
}

