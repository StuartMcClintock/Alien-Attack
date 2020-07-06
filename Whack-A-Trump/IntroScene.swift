//
//  IntroScene.swift
//  Whack-A-Trump
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
        
        let headingLabel = SKLabelNode(fontNamed: "Damascus-Bold")
        headingLabel.fontSize = 69.0
        headingLabel.fontColor = .white
        headingLabel.position = CGPoint(x: frame.midX, y: frame.midY+130)
        headingLabel.numberOfLines = 2
        headingLabel.text = "The White House\nis Under Attack!"
        addChild(headingLabel)
        
        let descLabel = SKLabelNode(fontNamed: "Damascus")
        descLabel.fontSize = 32.0
        descLabel.fontColor = .white
        descLabel.position = CGPoint(x: frame.midX, y: frame.midY-80)
        descLabel.numberOfLines = 2
        descLabel.text = "Tap the Trump faces that appear to ensure that\nfive don't exist on the screen at the same time."
        addChild(descLabel)
        
        let contLabel = SKLabelNode(fontNamed: "Damascus")
        contLabel.fontSize = 32.0
        contLabel.fontColor = .lightGray
        contLabel.position = CGPoint(x: frame.midX, y: frame.midY-250)
        contLabel.numberOfLines = 2
        contLabel.text = "(tap to begin)"
        addChild(contLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startNextScene()
    }
    
    func startNextScene(){
        let ogScene = GameScene(fileNamed: "SelectModeScene")
        ogScene?.scaleMode = .fill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
