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
    
    @IBOutlet weak var lblStatus: UILabel!
    var multipeerController: MultipeerController!
    var connectionType: ConnectionType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        connectionType = .host
        lblStatus.text = "Connect at least to two iPhone devices to have fun :)"
        MultipeerController.shared().delegate = self
        
    }
}

extension TvViewController: MultipeerHandler {
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        DispatchQueue.main.async {
                self.lblStatus.text = (id.displayName + " is trying to join.")
            }
            return MultipeerController.shared().connectedPeers.count < 6
    }
    
    func peerJoined(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has connected.")
        }
    }
    
    func peerLeft(_ id: MCPeerID) {
        DispatchQueue.main.async {
            self.lblStatus.text = (id.displayName + " has disconnected.")
          }
    }
}
