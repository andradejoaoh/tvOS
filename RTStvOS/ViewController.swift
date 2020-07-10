//
//  ViewController.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TvViewController: UIViewController {
    
    var multipeerController: MultipeerController!
    var connectionType: ConnectionType!
    

    @IBAction func connectPlayers(_ sender: Any) {
        if connectionType == .host {
            print("Sou host")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension TvViewController: MultipeerHandler {
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        return true
    }
    func peerJoined(_ id: MCPeerID) {
        print("Connected")
    }
}
