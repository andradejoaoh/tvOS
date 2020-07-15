//
//  GameController.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 03/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit
class GameController {
    var players: [Castle] = []
    var gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
}
