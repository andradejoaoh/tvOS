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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = "Connect an iPhone device..."
        MultipeerController.shared.delegate = self

    }
}
