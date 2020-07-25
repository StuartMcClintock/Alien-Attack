//
//  StoreScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/24/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene{
    
    var del: AppDelegate!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        addBackButton()
    }
    
    func addBackButton(){
        let pos = CGPoint(x:frame.midX, y:120)
        
        let button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 300, height: 100))
        button.name = "back"
        button.position = pos
        let buttonText = SKLabelNode(fontNamed: "DIN Alternate Bold")
        buttonText.text = "BACK"
        buttonText.name = "back"
        buttonText.fontSize = 62
        buttonText.color = SKColor.white
        buttonText.position = CGPoint(x:pos.x, y:pos.y-25.0)
        addChild(button)
        addChild(buttonText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            if touchedNode.name == "back"{
                returnToMain()
            }
        }
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        self.view?.presentScene(modeScene!, transition: .flipHorizontal(withDuration: 0.5))
    }
}
