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
        }
        return MultipeerController.shared().connectedPeers.count < 6
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
