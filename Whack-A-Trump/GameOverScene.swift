//
//  GameOverScence.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 6/23/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    override func didMove(to view: SKView){
        self.backgroundColor = SKColor.lightGray
        
        let overLabel = SKLabelNode(text: "Game Over")
        overLabel.fontSize = 84.0
        overLabel.fontColor = .black
        overLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        overLabel.fontName = "rockwell"
        addChild(overLabel)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        let ogScene = GameScene(fileNamed: "GameScene")
        ogScene?.scaleMode = .fill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
