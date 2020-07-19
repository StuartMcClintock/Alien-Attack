//
//  GameOverScence.swift
//  Alien-Attack
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
        
        let overLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        overLabel.fontSize = 84.0
        overLabel.fontColor = .black
        overLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(overLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        scoreLabel.fontSize = 84.0
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY+225)
        scoreLabel.text = String(del.recentScore)
        addChild(scoreLabel)
        
        if (del.recentScore > del.highScore){
            del.highScore = del.recentScore
            self.backgroundColor = SKColor.yellow
            overLabel.text = "New High Score!"
            
            if (del.isBlitz){
                UserDefaults.standard.set(del.highScore, forKey:"highScore-blitz")
            }
            else{
                UserDefaults.standard.set(del.highScore, forKey:"highScore-standard")
            }
        }
        else{
            overLabel.text = "Game Over"
            
            let highLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
            highLabel.fontSize = 62.0
            highLabel.fontColor = .black
            highLabel.position = CGPoint(x: frame.midX, y: frame.midY-200)
            if (del.isBlitz){
                highLabel.text = "Blitz High Score: \(del.highScore)"
            }
            else{
                highLabel.text = "High Score: \(del.highScore)"
            }
            addChild(highLabel)
        }
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
