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
        let headingLabel = SKLabelNode(fontNamed: "Damascus-Bold")
        headingLabel.fontSize = 69.0
        headingLabel.fontColor = .black
        headingLabel.position = CGPoint(x: frame.midX, y: frame.midY+120)
        headingLabel.numberOfLines = 2
        headingLabel.text = "The White House\nis Under Attack!"
        addChild(headingLabel)
        
        let descLabel = SKLabelNode(fontNamed: "Damascus")
        descLabel.fontSize = 32.0
        descLabel.fontColor = .black
        descLabel.position = CGPoint(x: frame.midX, y: frame.midY-100)
        descLabel.numberOfLines = 2
        descLabel.text = "Tap the Trump faces that appear to ensure that\nfive don't exist on the screen at the same time."
        addChild(descLabel)
        
        let contLabel = SKLabelNode(fontNamed: "Damascus")
        contLabel.fontSize = 32.0
        contLabel.fontColor = .darkGray
        contLabel.position = CGPoint(x: frame.midX, y: frame.midY-250)
        contLabel.numberOfLines = 2
        contLabel.text = "(tap to begin)"
        addChild(contLabel)
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
