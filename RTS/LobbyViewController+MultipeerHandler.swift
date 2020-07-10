//
//  ViewController+MultipeerHandler.swift
//  RTS
//
//  Created by Nathalia Melare on 09/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension LobbyViewController: MultipeerHandler {
    
    func peerDiscovered(_ id: MCPeerID) -> Bool {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " was found.")
        }
              host = id
              return true
    }
    
    func peerLost(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = ("Lost connection to " + id.displayName)
        }
    }
        
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has connected.")
            
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has disconnected.")
        }
    }
     
    func receivedData(_ data: Data, from peerID: MCPeerID) {
        print("recieved data")
        DispatchQueue.main.async {
            let t = String(data: data, encoding: .utf8)
            guard t != nil else {
                print("received message found nil")
                return
            }
            self.lblStatus.text = peerID.displayName + ": " + t!
        }
    }
}
