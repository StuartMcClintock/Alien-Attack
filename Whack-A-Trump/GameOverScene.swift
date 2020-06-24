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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        let ogScene = GameScene(fileNamed: "GameScene")
        ogScene?.scaleMode = .aspectFill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
