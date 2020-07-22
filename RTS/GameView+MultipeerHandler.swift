//
//  GameView+MultipeerHandler.swift
//  RTS
//
//  Created by Alex Nascimento on 21/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import MultipeerConnectivity

extension GameView : MultipeerHandler {
    
    func peerDiscovered(_ id: MCPeerID) -> Bool {
        return false
    }
    
    func peerLost(_ id: MCPeerID) {
        
    }
    
    
    func receivedData(_ data: Data, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            
            if peerID.displayName != hostName { return }
            guard let text = String(bytes: data, encoding: .utf8) else {return}
            
            let substrings = text.split(separator: ":")
            let funcName = substrings.first
            switch funcName {
            // "updateCastle:432_22" <- vida_arqueiros
            case "updateCastle":
                let parameters = substrings[1].split(separator: "_")
                if let hp = Int(parameters[0]) {
                    self.gameScene.gameController.castle.hp = hp
                    if hp == 0 {
                        self.gameScene.gameOver()
                    }
                }
                if let archers = Int(parameters[1]) {
                    self.gameScene.gameController.castle.archer = archers
                }
            case "youWon":
                self.gameScene.gameWon()
            case "draw":
                self.gameScene.draw()
            default:
                print ("[iOS] GameView receivedData: No func found with name \(text), from id \(peerID.description), self id \(MultipeerController.shared.myPeerID.description)")
            }
        }
    }
}
