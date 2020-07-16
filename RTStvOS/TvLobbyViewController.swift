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
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBAction func btnPlay(_ sender: Any) {
        startGame()
    }
    
    @IBOutlet weak var txtPlayers: UITextView!
 
    @IBOutlet weak var lblStatus: UILabel!
    
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = "Connect an iPhone device..."
        btnPlay.isHidden  = true
        MultipeerController.shared.delegate = self
    }
    
    func checkPlayersReady() {
        if countPlayersReady() >= 1 {
//            btnPlay.isHidden = false
            startGame()
        }
    }
    
    func startGame() {
//        self.present(GameView(), animated: false, completion: nil)
            self.performSegue(withIdentifier: "showGameView", sender: nil)
    }
    
    func countPlayersReady() -> Int {
        var count = 0
        for p in players {
            if p.isReady {
                count += 1
            }
        }
        return count
    }
}
