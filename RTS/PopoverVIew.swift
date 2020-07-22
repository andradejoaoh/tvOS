//
//  PopoverVIew.swift
//  RTS
//
//  Created by Nathalia Melare on 20/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SpriteKit

class PopoverView: SKScene {
    
       override func sceneDidLoad() {
         print("[iOS] PopoverView: sceneDidLoad")
         self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: 20, height: 20)
         self.backgroundColor = SKColor.red
     }
}
