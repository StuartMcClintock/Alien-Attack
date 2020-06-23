//
//  GameScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //var del: AppDelegate!
    
    var scoreLabel: SKLabelNode!
    var slots = [WhackSlot]()
    
    var scoreVal = 0{
        didSet{
            scoreLabel.text = "Score: \(scoreVal)"
        }
    }
    
    override func didMove(to view: SKView){
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.zPosition = -1;
        addChild(background)
        
        
        scoreLabel = SKLabelNode(fontNamed: "rockwell")
        scoreLabel.text = "Score: 0"
        //scoreLabel.position = CGPoint(x:85, y:30)
        scoreLabel.position = CGPoint(x:35, y:30)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        createSlot(at: CGPoint(x:frame.midX, y:frame.midY))
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        slots.append(slot)
    }
}
