//
//  iOSIconNode.swift
//  RTS
//
//  Created by João Henrique Andrade on 29/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit

class iOSIconNode: SKSpriteNode {
    init(imageNamed: String) {
        super.init(texture: SKTexture(imageNamed: imageNamed), color: .clear, size: CGSize(width: 80, height: 80))
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
