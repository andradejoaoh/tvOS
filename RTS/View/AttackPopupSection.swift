//
//  AttackPopupSection.swift
//  RTS
//
//  Created by Alex Nascimento on 22/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit

class AttackPopupSection: SKNode {
    
    var castleName: iOSLabelNode
    var minusButton: SKSpriteNode
    var plusButton: SKSpriteNode
    var valueLabel: iOSLabelNode
    var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }
    var padding: CGFloat = 20
    
    init(castleName: String, popupBounds: CGRect, posY: CGFloat) {
        self.castleName = iOSLabelNode(fontSize: 32, fontColor: .black, text: castleName)
        minusButton = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
        plusButton = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
        valueLabel = iOSLabelNode(fontSize: 32, fontColor: .black, text: "\(value)")
        super.init()
        self.castleName.position.y -= self.castleName.frame.height/2
        self.castleName.position.x = popupBounds.minX + self.castleName.frame.width/2 + 2*padding
        plusButton.position.x =  popupBounds.maxX - 2*padding - plusButton.size.width/2
        valueLabel.position.x = plusButton.position.x - plusButton.size.width/2 - padding - valueLabel.frame.width/2
        minusButton.position.x = valueLabel.position.x - valueLabel.frame.width/2 - padding - minusButton.size.width/2
        valueLabel.position.y = -valueLabel.frame.height/2
        self.position.y = posY
        addChild(self.castleName)
        addChild(minusButton)
        addChild(plusButton)
        addChild(valueLabel)
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let node = self.atPoint(location)
            if node === minusButton {
                value = value == 0 ? value : value - 1
            }
            else if node === plusButton {
                value += 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
