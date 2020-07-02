//
//  ViewController.swift
//  RTS
//
//  Created by João Henrique Andrade on 02/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resourcesLabel: UILabel!
    @IBOutlet weak var soldiersLabel: UILabel!
    var castle: Castle = Castle()

    override func viewDidLoad() {
        super.viewDidLoad()
        resourcesLabel.text = "Resources: \(castle.coins)"
        soldiersLabel.text = "Soldiers: \(castle.soldiers)"
    }
    
    @IBAction func createSoldierButton(_ sender: Any) {
        createSoldier { (sucess) in
            if sucess {
                updateLabels()
            }
        }
    }
    
    func updateLabels(){
        resourcesLabel.text = "Resources: \(castle.coins)"
        soldiersLabel.text = "Soldiers: \(castle.soldiers)"
    }
    
    func createSoldier(completion: (_ success: Bool) -> Void){
        castle.soldiers += 1
        castle.coins -= Soldier.price
        completion(true)
    }
}

