//
//  TvViewController+MultipeerHandler.swift
//  RTStvOS
//
//  Created by Nathalia Melare on 08/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension TvViewController: MultipeerHandler {
    
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " is trying to join.")
            let phonePlayer = Players (id: id.description)
            self.players.append(phonePlayer)
        }
        return MultipeerController.shared.connectedPeers.count < 6
    }
    
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has connected.")
            let data = "oioioio".data(using: .utf8)
            print("sending data")
            MultipeerController.shared.sendToPeers(data!, reliably: false, peers: [id])
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has disconnected.")
            let player = self.players.first { (player) -> Bool in
                      return player.id == id.description
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
            guard let texto = String(bytes: data, encoding: .utf8) else { return }
            var playerAux: Players?
             
            for index in 0..<self.players.count {
                if self.players[index].id == peerID.description {
                    playerAux = self.players[index]
                 }
             }
            guard let player = playerAux else { return }
            
            MultipeerController.shared.sendToPeers(data, reliably: false, peers: [peerID])
            }
        }
}
