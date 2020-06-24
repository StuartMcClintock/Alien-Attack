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
    var del: AppDelegate!
    
    override func didMove(to view: SKView){
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.lightGray
        
        let overLabel = SKLabelNode(fontNamed: "rockwell")
        overLabel.fontSize = 84.0
        overLabel.fontColor = .black
        overLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(overLabel)
        
        if (del.recentScore > del.highScore){
            del.highScore = del.recentScore
            self.backgroundColor = SKColor.yellow
            overLabel.text = "New High Score!"
        }
        else{
            overLabel.text = "Game Over"
        }
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
