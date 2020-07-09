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
        
}
