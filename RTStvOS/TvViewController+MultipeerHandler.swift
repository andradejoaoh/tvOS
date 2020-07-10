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
        return MultipeerController.shared.connectedPeers.count < 6
    }
    
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has connected.")
            let data = "oioioio".data(using: .utf8)
            print("sending data")
            MultipeerController.shared.sendToAllPeers(data!, reliably: true)
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
