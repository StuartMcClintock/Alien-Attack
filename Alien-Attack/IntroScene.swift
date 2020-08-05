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
    
    var contLabel:SKLabelNode?
    var saucer:SKSpriteNode?
    var displayLabel:SKLabelNode!
    
    var showsCont = true
    
    let messages:[String] = ["   Tap on the alien faces that pop up to\nremove them. Make sure that five faces don't\n   remain on the screen at the same time!", "big chungus"]
    
    var stage:Int? = 0
    
    override func didMove(to view: SKView){
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        makeLandingNoise()
        displayBackground()
        introAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8, execute: { [weak self] in
            self?.untappedIntro()
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            if touchedNode.name == "skip"{
                startNextScene()
            }
        }
        
        if showsCont{
            contLabel?.removeFromParent()
            showsCont = false
        }
        
        if (stage == 0){
            displayIntro()
        }
        else{
            updateMessage(index: stage!-1)
        }
        
        stage? += 1
    }
    
    func updateMessage(index:Int){
        if index >= messages.count{
            startNextScene()
            return
        }
        displayLabel.fontSize = 30.0
        displayLabel.position = CGPoint(x: frame.midX, y: frame.midY-170)
        displayLabel.text = messages[index]
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
        saucer = SKSpriteNode(imageNamed: "saucer")
        saucer?.zPosition = 0
        saucer?.position = CGPoint(x: frame.midX, y: frame.maxY+100)
        saucer?.size = CGSize(width: 500, height: 184)
        addChild(saucer!)
        let saucerPath = SKAction.moveTo(y: 200, duration: 3.3)
        saucer?.run(saucerPath)
    }
    
    func displayBackground(){
        background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.alpha = 1
        background.zPosition = -1
        addChild(background)
    }
    
    func untappedIntro(){
        if (stage != 0){
            return
        }
        stage = 1
        displayIntro()
    }
    
    func displayIntro(){
        background.alpha = 0.5
        
        displayLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        displayLabel.fontSize = 72
        displayLabel.fontColor = .white
        displayLabel.position = CGPoint(x: frame.midX, y: frame.midY-175)
        displayLabel.numberOfLines = 3
        displayLabel.text = "THE WHITE HOUSE\n        IS UNDER\n ALIEN INVASION!"
        addChild(displayLabel)
        
        contLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        contLabel?.fontSize = 32
        contLabel?.fontColor = SKColor.white
        contLabel?.alpha = 0.5
        contLabel?.position = CGPoint(x: frame.midX, y: 230)
        contLabel?.numberOfLines = 2
        contLabel?.text = "(tap screen for instructions)"
        addChild(contLabel!)
        showsCont = true
        
        saucer?.removeFromParent()
        addSkipButton()
    }
    
    func addSkipButton(){
        
        let skipButton = SKSpriteNode(color: SKColor.white, size: CGSize(width: 250, height: 80))
        skipButton.position = CGPoint(x: frame.midX, y: 100)
        skipButton.name = "skip"
        skipButton.color = SKColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        addChild(skipButton)
        
        let skipText = SKLabelNode(fontNamed: "DIN Alternate Bold")
        skipText.position = CGPoint(x: frame.midX, y: 120)
        skipText.verticalAlignmentMode = .top
        skipText.fontSize = 50
        skipText.text = "Skip >>>"
        skipText.name = "skip"
        skipText.fontColor = SKColor.init(red: 50/255, green: 60/255, blue: 9/255, alpha: 1)
        addChild(skipText)
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
