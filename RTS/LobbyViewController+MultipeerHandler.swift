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
        if id.displayName == hostName {
            MultipeerController.shared.host = id
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has disconnected.")
        }
    }
    
    func receivedData(_ data: Data, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            
            if peerID.displayName != hostName { return }
            guard let text = String(bytes: data, encoding: .utf8) else {return}
            
            let substrings = text.split(separator: ":")
            let funcName = substrings.first
            switch funcName {
            case "isReadyConfirmation":
                print("[iOS] LobbyViewController receivedData: isReadyConfirmation")
                self.imgCheck.image = UIImage.init(systemName: "checkmark.square.fill")
                self.isReady = true
            case "isNotReadyConfirmation":
                self.imgCheck.image = UIImage.init(systemName: "square.fill")
                self.isReady = false
            case "gameStart":
                MultipeerController.shared.myCastle = Castle(named: String(substrings[1]))
                self.getCastles()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showGameView", sender: nil)
                }
            default:
                print ("[iOS] LobbyViewController receivedData: No func found with name \(text), from id \(peerID.description), self id \(MultipeerController.shared.myPeerID.description)")
            }
        }
    }
    
    func getCastles() -> [String] {
        for p in MultipeerController.shared.players {
                return [p.castle.name]
        }
        fatalError("getCastles: Didn't find castles")
    }

}

