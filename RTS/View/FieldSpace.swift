//
//  FieldSpace.swift
//  RTS
//
//  Created by Alex Nascimento on 28/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit

class FieldSpace {
    
    unowned var emptyFieldNode: SKSpriteNode
    unowned var farmNode: SKSpriteNode
    unowned var triggerBox: SKShapeNode
    var isFarmEnabled: Bool {
        didSet {
            if isFarmEnabled {
                emptyFieldNode.isHidden = true
                farmNode.isHidden = false
            } else {
                emptyFieldNode.isHidden = false
                farmNode.isHidden = true
            }
        }
    }
    
    init(emptyField: SKSpriteNode, farm: SKSpriteNode, trigger: SKShapeNode, _ farmEnabled: Bool) {
        self.emptyFieldNode = emptyField
        self.farmNode = farm
        self.triggerBox = trigger
        self.isFarmEnabled = farmEnabled
    }
    
    func toogleFarm() {
        if isFarmEnabled {
            emptyFieldNode.isHidden = false
            farmNode.isHidden = true
            isFarmEnabled = true
        } else {
            emptyFieldNode.isHidden = true
            farmNode.isHidden = false
            isFarmEnabled = false
        }
    }
}
