//
//  IntroScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 6/25/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

import AVFoundation

class IntroScene: SKScene{
    
    var audioPlayer: AVAudioPlayer?
    var del: AppDelegate!
    
    var background:SKSpriteNode!
    
    override func didMove(to view: SKView){
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        makeLandingNoise()
        displayBackground()
        introAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8, execute: { [weak self] in
            self?.displayText()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startNextScene()
    }
    
    func makeLandingNoise(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let soundPath = Bundle.main.path(forResource: "shipLanding-faster", ofType: "mp3")
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
            audioPlayer?.play()
        }
        catch {}
    }
    
    func introAnimation(){
        let saucer = SKSpriteNode(imageNamed: "saucer")
        saucer.zPosition = 0
        saucer.position = CGPoint(x: frame.midX, y: frame.maxY+100)
        saucer.size = CGSize(width: 500, height: 184)
        addChild(saucer)
        let saucerPath = SKAction.moveTo(y: 200, duration: 3.3)
        saucer.run(saucerPath)
    }
    
    func displayBackground(){
        background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
    }
    
    func displayText(){
        background.alpha = 0.3
        
        let headingLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        headingLabel.fontSize = 52
        headingLabel.fontColor = .white
        headingLabel.position = CGPoint(x: frame.midX, y: frame.midY+135)
        headingLabel.numberOfLines = 2
        headingLabel.text = "   THE WHITE HOUSE IS\nUNDER ALIEN INVASION!"
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
    
    func startNextScene(){
        del.buttonSound()
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        if UIDevice.current.model == "iPad"{
            modeScene?.scaleMode = .fill
        }
        self.view?.presentScene(modeScene!)
    }
}
