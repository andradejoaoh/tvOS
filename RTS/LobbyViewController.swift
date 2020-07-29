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
            MultipeerController.shared.sendToHost(msg: "ready")
        } else {
            MultipeerController.shared.sendToHost(msg: "notReady")
        }
    }
    
    @IBOutlet weak var imgCheck: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        #if OFFLINE
            showGameView()
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblStatus.text = ("Connect to an AppleTV to begin your fun!")
        MultipeerController.shared.startBrowsing()
        MultipeerController.shared.delegate = self
        setReady(false)
    }
    
    func setReady(_ state: Bool) {
        if state {
            self.imgCheck.image = UIImage.init(systemName: "checkmark")
            self.imgCheck.tintColor = .systemGreen
            self.isReady = true
        } else {
            self.imgCheck.image = UIImage.init(systemName: "xmark")
            self.imgCheck.tintColor = #colorLiteral(red: 0.6073825955, green: 0.1656134129, blue: 0.09109530598, alpha: 1)
            self.isReady = false
        }
    }
    
    func showGameView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showGameView", sender: nil)
        }
    }
}
