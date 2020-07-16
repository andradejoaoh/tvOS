//
//  TvViewController+MultipeerHandler.swift
//  RTStvOS
//
//  Created by Nathalia Melare on 08/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//


import Foundation
import MultipeerConnectivity

extension TvLobbyViewController: MultipeerHandler {
    
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " is trying to join.")
        }
        return MultipeerController.shared.connectedPeers.count < 6
    }
    
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has connected.")
            self.txtPlayers.text += (id.displayName + " has connected.\n")
            let phonePlayer = Player (id: id, castle: Castle(), isReady: false)
                self.players.append(phonePlayer)
            
            let data = "oioioio".data(using: .utf8)
            print("sending data")
            MultipeerController.shared.sendToPeers(data!, reliably: false, peers: [id])
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has disconnected.")
            self.txtPlayers.text += (id.displayName + " has disconnected.\n")
            let player = self.players.first { (player) -> Bool in
                return player.id == id
            }
            let seconds = 5.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.players.removeAll { (removingPlayer) -> Bool in
                    player?.id == removingPlayer.id
                }
            }
        }
    }
    
    func receivedData(_ data: Data, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let text = String(bytes: data, encoding: .utf8) else { return }
            var playerAux: Player?
            
            for index in 0..<self.players.count {
                if self.players[index].id == peerID {
                    playerAux = self.players[index]
                }
            }
            guard let player = playerAux else { return }
            
            let substrings = text.split(separator: ":")
            let funcName = substrings.first
            switch funcName {
            case "sendArmy":
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
            case "ready":
                player.isReady = true
                guard let data = "isReadyConfirmation".data(using: .utf8) else {return}
                self.checkPlayersReady()
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [player.id])
            case "notReady":
                player.isReady = false
                guard let data = "isNotReadyConfirmation".data(using: .utf8) else {return}
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [player.id])

            default:
                print ("TvLobbyViewController receivedData: No func found with name \(text) ")
            }
            
            MultipeerController.shared.sendToAllPeers(data, reliably: true)
        }
    }
    
    func sendArmy(soldiers: Int, fromCity: String, toCity: String) {
        print("\(soldiers),\(fromCity),\(toCity)")
    }
    
    func addArcher(archers: Int, onCity: String) {
       getCastle(named: onCity).archer += archers
    }
    
    func getCastle(named: String) -> Castle {
        for p in players {
            if p.castle.name == named {
                return p.castle
            }
        }
        fatalError("getCastle: Didn't find castle with name \(named)")
    }
    
}
