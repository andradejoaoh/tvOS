//
//  LobbyViewController.swift
//  RTS
//
//  Created by Nathalia Melare on 09/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    var host: MCPeerID?
    @IBOutlet weak var btnStarGame: UIButton!
    @IBOutlet weak var btnReady: UIButton!
    var isReady = false
    @IBAction func btnReady(_ sender: Any) {
        if isReady == false {
            guard let text = "ready".data(using: .utf8) else {return}
            guard let host = host else {return}
            MultipeerController.shared.sendToPeers(text, reliably: true, peers: [host])
        } else {
            guard let text = "notReady".data(using: .utf8) else {return}
            guard let host = host else {return}
            MultipeerController.shared.sendToPeers(text, reliably: true, peers: [host])
        }
    }
    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBAction func buttonClick(_ sender: Any) {
        let data = "sendArmy:23_Siena_Bologna".data(using: .utf8)
        print("iPhone sending data")
        MultipeerController.shared.sendToAllPeers(data!, reliably: true)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        lblStatus.text = ("Connect to an AppleTV to begin your fun!")
        MultipeerController.shared.delegate = self
        btnStarGame.isEnabled = false
    }
}
