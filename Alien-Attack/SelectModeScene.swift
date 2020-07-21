//
//  SelectModeScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class SelectModeScene: SKScene{
    var del: AppDelegate!
    
    var soundButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.alpha = 0.2
        background.zPosition = -1
        addChild(background)
        
        addSceneButtons()
        initSoundButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            if touchedNode.name == "blitz"{
                del.isBlitz = true
                del.highScore = UserDefaults.standard.integer(forKey: "highScore-blitz")
                del.buttonSound()
                startGame()
            }
            if touchedNode.name == "standard"{
                del.isBlitz = false
                del.highScore = UserDefaults.standard.integer(forKey: "highScore-standard")
                del.buttonSound()
                startGame()
            }
            if touchedNode.name == "awards"{
                del.buttonSound()
                dispAwards()
            }
            if touchedNode.name == "sound"{
                soundPressed()
                del.buttonSound()
            }
        }
    }
    
    func addSceneButtons(){
        let buttonSize = CGSize(width: 500, height: 120)
        let standardButtonColor = SKColor.init(displayP3Red: 71/255, green: 145/255, blue: 214/255, alpha: 1)
        let blitzButtonColor = SKColor.red
        let awardButtonColor = SKColor.init(displayP3Red: 184/255, green: 156/255, blue: 20/255, alpha: 1)
        
        let standardPointPosition = CGPoint(x: frame.midX, y: frame.midY+200)
        let blitzPointPosition = CGPoint(x: frame.midX, y: frame.midY)
        let awardPointPosition = CGPoint(x: frame.midX, y: frame.midY-200)
        
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
        
        let awardButton = SKSpriteNode(color: awardButtonColor, size: buttonSize)
        awardButton.position = awardPointPosition
        awardButton.name = "awards"
        addChild(awardButton)
        let awardText = SKLabelNode(text: "View Awards")
        awardText.position = CGPoint(x:awardPointPosition.x, y:awardPointPosition.y-25)
        awardText.fontName = "DIN Alternate Bold"
        awardText.fontColor = SKColor.white
        awardText.fontSize = 68
        awardText.name = "awards"
        addChild(awardText)
    }
    
    func initSoundButton(){
        del.isMute = UserDefaults.standard.bool(forKey: "isMute")
        if del.isMute{
            soundButton = SKSpriteNode(imageNamed: "notMute")
        }
        else{
            soundButton = SKSpriteNode(imageNamed: "mute")
        }
        soundButton.size = CGSize(width: 100, height: 100)
        soundButton.position = CGPoint(x: frame.midX, y: 100)
        soundButton.name = "sound"
        addChild(soundButton)
    }
    
    func soundPressed(){
        del.isMute = !del.isMute
        UserDefaults.standard.set(del.isMute, forKey: "isMute")
        if del.isMute{
            soundButton.texture = SKTexture(imageNamed: "notMute")
        }
        else{
            soundButton.texture = SKTexture(imageNamed: "mute")
        }
    }
    
    func startGame(){
        let scene = GameScene(fileNamed: "GameScene")
        scene?.scaleMode = .fill
        self.view?.presentScene(scene!, transition: .flipVertical(withDuration: 0.5))
    }
    
    func dispAwards(){
        let scene = GameScene(fileNamed: "AwardDisplayScene")
        scene?.scaleMode = .fill
        self.view?.presentScene(scene!, transition: .flipVertical(withDuration: 0.5))
    }
}
