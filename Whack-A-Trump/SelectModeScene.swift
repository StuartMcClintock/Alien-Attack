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
    var del: AppDelegate!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.alpha = 0.2
        background.zPosition = -1
        addChild(background)
        
        
        let headerLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        headerLabel.fontSize = 94.0
        headerLabel.fontColor = .white
        headerLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 330)
        headerLabel.text = "Select Mode:"
        addChild(headerLabel)
        
        let buttonSize = CGSize(width: 500, height: 120)
        
        let standardPointPosition = CGPoint(x: frame.midX, y: frame.midY-30)
        let standardButtonColor = SKColor.init(displayP3Red: 71/255, green: 145/255, blue: 214/255, alpha: 1)
        
        let blitzPointPosition = CGPoint(x: frame.midX, y: frame.midY-250)
        let blitzButtonColor = SKColor.red
        
        
        let standardButton = SKSpriteNode(color: standardButtonColor, size: buttonSize)
        standardButton.position = standardPointPosition
        standardButton.name = "standard"
        addChild(standardButton)
        let standardText = SKLabelNode(text: "Standard")
        standardText.position = CGPoint(x:standardPointPosition.x, y:standardPointPosition.y-25)
        standardText.fontName = "DIN Alternate Bold"
        standardText.fontColor = SKColor.white
        standardText.fontSize = 74
        standardText.name = "standard"
        addChild(standardText)
        
        let blitzButton = SKSpriteNode(color: blitzButtonColor, size: buttonSize)
        blitzButton.position = blitzPointPosition
        blitzButton.name = "blitz"
        addChild(blitzButton)
        let blitzText = SKLabelNode(text: "BLITZ ! !")
        blitzText.position = CGPoint(x:blitzPointPosition.x, y:blitzPointPosition.y-27)
        blitzText.fontName = "DIN Alternate Bold"
        blitzText.fontColor = SKColor.white
        blitzText.fontSize = 74
        blitzText.name = "blitz"
        addChild(blitzText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            if touchedNode.name == "blitz"{
                del.isBlitz = true
                startGame()
            }
            if touchedNode.name == "standard"{
                del.isBlitz = false
                startGame()
            }
        }
    }
    
    func startGame(){
        let ogScene = GameScene(fileNamed: "GameScene")
        ogScene?.scaleMode = .fill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
}
