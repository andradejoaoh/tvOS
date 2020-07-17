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
    @IBOutlet weak var btnReady: UIButton!
    var isReady = false
    @IBAction func btnReady(_ sender: Any) {
        if !isReady {
            guard let text = "ready".data(using: .utf8) else {return}
            guard let host = MultipeerController.shared.host else {return}
            MultipeerController.shared.sendToPeers(text, reliably: true, peers: [host])
        } else {
            guard let text = "notReady".data(using: .utf8) else {return}
            guard let host = MultipeerController.shared.host else {return}
            MultipeerController.shared.sendToPeers(text, reliably: true, peers: [host])
        }
    }
    
    @IBOutlet weak var imgCheck: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ("Connect to an AppleTV to begin your fun!")
        MultipeerController.shared.delegate = self
    }
}
