//
//  SelectModeScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 7/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class SelectModeScene: SKScene{
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.init(displayP3Red: 128, green: 235, blue: 255, alpha: 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startGame()
    }
    
    func startGame(){
        let ogScene = GameScene(fileNamed: "GameScene")
        ogScene?.scaleMode = .fill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
