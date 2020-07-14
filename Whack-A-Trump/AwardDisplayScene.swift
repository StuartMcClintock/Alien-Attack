//
//  AwardDisplayScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 7/12/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class AwardDisplayScene: SKScene{
    override func didMove(to view: SKView) {
        //pass
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        let ogScene = GameScene(fileNamed: "SelectModeScene")
        ogScene?.scaleMode = .aspectFill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
