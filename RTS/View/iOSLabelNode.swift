//
//  iOSLabelNode.swift
//  RTS
//
//  Created by João Henrique Andrade on 07/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit
class iOSLabelNode: SKLabelNode {
    
    init(fontSize: Int, fontColor: UIColor, text: String){
        super.init()
        self.fontName = "Arial"
        self.fontSize = CGFloat(fontSize)
        self.fontColor = fontColor
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
