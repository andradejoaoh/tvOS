//
//  Players.swift
//  RTS
//
//  Created by Nathalia Melare on 14/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//
import MultipeerConnectivity

public class Player {
    let id: MCPeerID
    var castle: Castle
    var isReady: Bool

    public init (id: MCPeerID, castle: Castle, isReady: Bool) {
        self.id = id
        self.castle = castle
        self.isReady = isReady
    }
    
    func removePlayer() {
        MultipeerController.shared.players.removeAll { (removingPlayer) -> Bool in
            self === removingPlayer
        }
    }
}