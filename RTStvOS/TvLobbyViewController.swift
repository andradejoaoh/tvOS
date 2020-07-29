//
//  ViewController.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TvLobbyViewController: UIViewController {
     
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblStatus.text = "Connect an iPhone device..."
        MultipeerController.shared.delegate = self
        MultipeerController.shared.startAdvertising()
        for p in MultipeerController.shared.players {
            p.isReady = false
            p.castle = Castle()
        }
        MultipeerController.shared.castles.removeAll()
        checkForConnectedPlayers()
    }
    
    func updateStatus(_ newMessage: String) {
        self.lblStatus.text = newMessage
    }
    
    func checkForConnectedPlayers() {
        for player in MultipeerController.shared.players {
            DispatchQueue.main.async {
                self.updateStatus(player.id.displayName + " has connected.")
            }
        }
    }
    
    func checkPlayersReady() {
        if countPlayersReady() >= 2 {
            if countPlayersReady() == MultipeerController.shared.players.count {
                startGame()
            }
        }
    }
    
    func startGame() {
        MultipeerController.shared.stopAdvertising()
        for p in MultipeerController.shared.players {
            var gameStartMsg = "gameStart:\(p.castle.name)"
            for other in MultipeerController.shared.players {
                if other !== p {
                    gameStartMsg += "_\(other.castle.name)"
                }
            }
            if let data = gameStartMsg.data(using: .utf8) {
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [p.id])
            }
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showGameView", sender: nil)
        }
    }
    
    private func countPlayersReady() -> Int {
        var count = 0
        for p in MultipeerController.shared.players {
            if p.isReady {
                count += 1
            }
        }
        return count
    }
}
