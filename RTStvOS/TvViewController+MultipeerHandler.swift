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
            let phonePlayer = Player (id: id.description)
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
            guard let text = String(bytes: data, encoding: .utf8) else { return }
            var playerAux: Player?
             
            for index in 0..<self.players.count {
                if self.players[index].id == peerID.description {
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
                   default:
                       print ("No func found with that name ")
                   }
            
            MultipeerController.shared.sendToAllPeers(data, reliably: true)
            }
        }
    
    func sendArmy(soldiers: Int, fromCity: String, toCity: String) {
       print("\(soldiers),\(fromCity),\(toCity)")
    }
    
    func addArcher(archers: Int, fromCity: String) {
        
    }
}
