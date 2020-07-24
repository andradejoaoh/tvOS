//
//  AttackPopup.swift
//  RTS
//
//  Created by Alex Nascimento on 22/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit

class AttackPopup: SKSpriteNode {
    
    unowned var gameScene: GameScene
    var myCastle: Castle {
        return gameScene.gameController.castle
    }
    var backgroundNode: SKSpriteNode
    var sections: [AttackPopupSection] = []
    var sendAttackBtn: SKSpriteNode = SKSpriteNode()
    var spacing: CGFloat = 160
    
    init(castleNames: [String], scene: GameScene) {
        gameScene = scene
        backgroundNode = SKSpriteNode(color: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3), size: scene.frame.size)

        super.init(texture: SKTexture(imageNamed: "popupBackground"), color: .clear, size: CGSize(width: 600, height: 900))
        sendAttackBtn = SKSpriteNode(texture: SKTexture(imageNamed: "popupAttackButton"), size: CGSize(width: self.frame.width/1.3, height: 100))

        for i in 0..<castleNames.count {
            let newSection = AttackPopupSection(castleName: castleNames[i], popupBounds: self.frame, posY: self.frame.maxY - spacing/1.5 - (CGFloat(i) * spacing), parent: self)
            sections.append(newSection)
            addChild(newSection)
        }
        self.zPosition = 10
        self.isUserInteractionEnabled = true
        addChild(backgroundNode)
        backgroundNode.zPosition = -1
        sendAttackBtn.position.y = self.frame.minY + spacing/2 + sendAttackBtn.frame.height/2
        addChild(sendAttackBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendAttack() {
        for s in sections {
            if s.value > 0 {
                let soldiers = s.value
                guard let toCity = s.castleName.text else { return }
                MultipeerController.shared.sendToHost(msg: "sendArmy:\(soldiers)_\(myCastle.name)_\(toCity)")
            }
        }
        gameScene.updateLabel()
    }
    
    func dismissPopup() {
        gameScene.attackPopup = nil
        self.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let node = self.atPoint(location)
            if node === sendAttackBtn {
                sendAttack()
                dismissPopup()
            }
            else if node === backgroundNode {
                dismissPopup()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
