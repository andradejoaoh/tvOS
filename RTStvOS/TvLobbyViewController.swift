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
    
    
    @IBOutlet weak var txtPlayers: UITextView!
 
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = "Connect an iPhone device..."
        MultipeerController.shared.delegate = self
    }
    
    func checkPlayersReady() {
        if countPlayersReady() >= 2 {
            startGame()
        }
    }
    
    func startGame() {
        MultipeerController.shared.stopAdvertising()
        for p in MultipeerController.shared.players {
            if let data = "gameStart:\(p.castle.name)".data(using: .utf8) {
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [p.id])
            }
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showGameView", sender: nil)
        }
    }
    
    func countPlayersReady() -> Int {
        var count = 0
        for p in MultipeerController.shared.players {
            if p.isReady {
                count += 1
            }
        }
        return count
    }
}
