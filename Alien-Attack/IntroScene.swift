//
//  IntroScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 6/25/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class IntroScene: SKScene{
    
    override func didMove(to view: SKView){
        self.backgroundColor = SKColor.white
        
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.alpha = 0.3
        background.zPosition = -1
        addChild(background)
        
        let headingLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        headingLabel.fontSize = 68.0
        headingLabel.fontColor = .white
        headingLabel.position = CGPoint(x: frame.midX, y: frame.midY+135)
        headingLabel.numberOfLines = 2
        headingLabel.text = "There is a battle for\n  the White House!"
        addChild(headingLabel)
        
        let descLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        descLabel.fontSize = 30.0
        descLabel.fontColor = .white
        descLabel.position = CGPoint(x: frame.midX, y: frame.midY-170)
        descLabel.numberOfLines = 3
        descLabel.text = "   Tap on the alien faces that pop up to\nremove them. Make sure that five faces don't\n   remain on the screen at the same time!"
        addChild(descLabel)
        
        let contLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        contLabel.fontSize = 38.0
        contLabel.fontColor = .lightGray
        contLabel.position = CGPoint(x: frame.midX, y: frame.midY-370)
        contLabel.numberOfLines = 2
        contLabel.text = "(tap to begin)"
        addChild(contLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startNextScene()
    }
    
    func startNextScene(){
        let ogScene = GameScene(fileNamed: "SelectModeScene")
        ogScene?.scaleMode = .aspectFill
        self.view?.presentScene(ogScene!)
    }
}
