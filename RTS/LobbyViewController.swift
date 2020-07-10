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

    override func viewDidLoad() {
         super.viewDidLoad()
        
        lblStatus.text = ("Connect to an AppleTV to begin your fun!")
        MultipeerController.shared().delegate = self
    }
    
    
}
