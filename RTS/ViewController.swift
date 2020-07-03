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
    var createSoldierIsRunning: Bool = false
    
    var soldiersInQueue: Int = 0 {
        didSet{
            if createSoldierIsRunning == false{
                createSoldier()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resourcesLabel.text = "Resources: \(castle.coins)"
        soldiersLabel.text = "Soldiers: \(castle.soldiers)"
    }
    
    @IBAction func createSoldierButton(_ sender: Any) {
        soldiersInQueue += 1
        
    }
    
    func updateLabels(){
        resourcesLabel.text = "Resources: \(castle.coins)"
        soldiersLabel.text = "Soldiers: \(castle.soldiers)"
    }
    
    
    func createSoldier(){
        self.createSoldierIsRunning = true
        castle.coins -= Soldier.price
        soldiersInQueue -= 1
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.castle.soldiers += 1
            self.updateLabels()
            self.createSoldierIsRunning = false
            
            if self.soldiersInQueue == 0 {
                timer.invalidate()
            } else if self.soldiersInQueue > 0 {
                self.createSoldier()
            }
        }
    }
}

