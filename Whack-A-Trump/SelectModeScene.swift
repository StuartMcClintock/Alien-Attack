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
        let headerLabel = SKLabelNode(fontNamed: "Damascus")
        headerLabel.fontSize = 94.0
        headerLabel.fontColor = .black
        headerLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 220)
        headerLabel.text = "Select Mode:"
        addChild(headerLabel)
        
        let buttonSize = CGSize(width: 500, height: 120)
        
        let standardPointPosition = CGPoint(x: frame.midX, y: frame.midY+100)
        let standardButtonColor = SKColor.init(displayP3Red: 71/255, green: 145/255, blue: 214/255, alpha: 1)
        
        let blitzPointPosition = CGPoint(x: frame.midX, y: frame.midY-100)
        let blitzButtonColor = SKColor.red
        
        
        let standardButton = SKSpriteNode(color: standardButtonColor, size: buttonSize)
        standardButton.position = standardPointPosition
        addChild(standardButton)
        let standardText = SKLabelNode(text: "Standard")
        standardText.position = CGPoint(x:standardPointPosition.x, y:standardPointPosition.y-25)
        standardText.fontName = "DIN Alternate Bold"
        standardText.fontColor = SKColor.white
        standardText.fontSize = 74
        addChild(standardText)
        
        let blitzButton = SKSpriteNode(color: blitzButtonColor, size: buttonSize)
        blitzButton.position = blitzPointPosition
        addChild(blitzButton)
        let blitzText = SKLabelNode(text: "BLITZ ! !")
        blitzText.position = CGPoint(x:blitzPointPosition.x, y:blitzPointPosition.y-25)
        blitzText.fontName = "DIN Alternate Bold"
        blitzText.fontColor = SKColor.white
        blitzText.fontSize = 74
        addChild(blitzText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            print(touch.location(in: self))
        }
        startGame()
    }
    
    func startGame(){
        let ogScene = GameScene(fileNamed: "GameScene")
        ogScene?.scaleMode = .fill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
