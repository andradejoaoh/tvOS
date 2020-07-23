//
//  AttackPopup.swift
//  RTS
//
//  Created by Alex Nascimento on 22/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SpriteKit

class AttackPopup: SKSpriteNode {
    
    weak var gameScene: GameScene?
    var backgroundNode: SKSpriteNode
    var sections: [AttackPopupSection] = []
    var sendAttackBtn: SKSpriteNode
    var spacing: CGFloat = 100
    
    init(castleNames: [String], scene: GameScene) {
        gameScene = scene
        backgroundNode = SKSpriteNode(color: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3), size: scene.frame.size)
        sendAttackBtn = SKSpriteNode(color: .systemRed, size: CGSize(width: 200, height: 100))
        super.init(texture: nil, color: .cyan, size: CGSize(width: 500, height: 800))
        for i in 0..<castleNames.count {
            let newSection = AttackPopupSection(castleName: castleNames[i], popupBounds: self.frame, posY: self.frame.maxY - spacing/2 - (CGFloat(i) * spacing))
            sections.append(newSection)
            addChild(newSection)
        }
        self.zPosition = 100
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
                guard let host = MultipeerController.shared.host else { return }
                guard let myCastle = gameScene?.gameController.castle else { return }
                guard let data = "sendArmy:\(soldiers)_\(myCastle.name)_\(toCity)".data(using: .utf8) else { return }
                MultipeerController.shared.sendToPeers(data, reliably: true, peers: [host])
                myCastle.soldier -= soldiers
            }
        }
        gameScene?.updateLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let node = self.atPoint(location)
            if node === sendAttackBtn {
                sendAttack()
            }
            else if node === backgroundNode {
                gameScene?.attackPopup = nil
                self.removeFromParent()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
