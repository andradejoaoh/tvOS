//
//  TvViewController+MultipeerHandler.swift
//  RTStvOS
//
//  Created by Nathalia Melare on 08/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import MultipeerConnectivity

extension TvLobbyViewController: MultipeerHandler {
    
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        DispatchQueue.main.async {
            self.updateStatus(id.displayName + " is trying to join.")
        }
        return MultipeerController.shared.connectedPeers.count < 6
    }
    
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.updateStatus(id.displayName + " has connected.")
            let phonePlayer = Player(id: id, castle: Castle(), isReady: false)
            MultipeerController.shared.players.append(phonePlayer)
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.updateStatus(id.displayName + " has disconnected.")
            let player = MultipeerController.shared.players.first { (player) -> Bool in
                return player.id == id
            }
            MultipeerController.shared.players.removeAll { (removingPlayer) -> Bool in
                player === removingPlayer
            }
        }
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
            case "ready":
                player.isReady = true
                self.updateStatus("\(peerID.displayName) is READY")
                guard let data = "isReadyConfirmation".data(using: .utf8) else {return}
                self.checkPlayersReady()
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [player.id])
            case "notReady":
                player.isReady = false
                self.updateStatus("\(peerID.displayName) is NOT READY")
                guard let data = "isNotReadyConfirmation".data(using: .utf8) else {return}
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [player.id])

            default:
                print ("TvLobbyViewController receivedData: No func found with name \(text) ")
            }
            
            MultipeerController.shared.sendToAllPeers(data, reliably: true)
        }
    }
    
}
