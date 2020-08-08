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

import GoogleMobileAds

class IntroScene: SKScene{
    struct instrImg{
        var image: SKSpriteNode
        var location: CGPoint
        var scaleAmount: CGFloat
        var animationKey: String?
        var textureList: [SKTexture]?
        var timePerFrame: TimeInterval?
        init(imageName:String, loc:CGPoint, sa: CGFloat, initSize: CGSize){
            image = SKSpriteNode(imageNamed: imageName)
            image.position = loc
            image.size = initSize
            location = loc
            scaleAmount = sa
        }
        init(texture:SKTexture, loc:CGPoint, sa: CGFloat, initSize: CGSize, tl: [SKTexture], key:String?, tpf:TimeInterval){
            image = SKSpriteNode(texture: texture)
            image.position = loc
            image.size = initSize
            location = loc
            scaleAmount = sa
            animationKey = key
            textureList = tl
            timePerFrame = tpf
        }
    }
    
    var audioPlayer: AVAudioPlayer?
    var del: AppDelegate!
    
    var background:SKSpriteNode!
    
    var contLabel:SKLabelNode?
    var saucer:SKSpriteNode?
    var displayLabel:SKLabelNode!
    
    var showsCont = true
    
    var messages:[String] = []
    var instrImgs:[instrImg?] = []
    
    var stage:Int? = 0
    
    override func didMove(to view: SKView){
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        /*
         let goldImage = SKSpriteNode(texture: del.coinFrames[0])
         goldImage.position = CGPoint(x: 290, y: frame.maxY-yOffset+(innerGap/2))
         goldImage.size = CGSize(width:65, height:65)
         addChild(goldImage)
         goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
         */
        
        messages = ["       Tap on the alien faces that pop up to\nremove them. Make sure that five faces don't\n    remain on the screen at the same time!","   You can play in either STANDARD or BLITZ\n mode and will get a point for each alien killed.\nWin awards based on points scored and mode.", "        You will earn coins for scoring points.\n1 coin = \(del.pointsPerGold_STANDARD) points in STANDARD and \(del.pointsPerGold_BLITZ) in BLITZ.\n      Coins are also given for certain awards."]
        instrImgs = [instrImg(imageName: "greenAlien", loc: CGPoint(x: frame.midX, y: 350), sa: 1.5, initSize: del.greenAlienSize), instrImg(imageName: "standardGold", loc: CGPoint(x: frame.midX, y: 325), sa: 1.2, initSize: CGSize(width: 110, height: 200)), instrImg(texture: del.coinFrames[0], loc: CGPoint(x: frame.midX, y: 325), sa: 1.3, initSize: CGSize(width: 100, height: 100), tl: del.coinFrames, key: "rotatingCoin", tpf:0.035)]
        
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
            updateAnimation(index: stage!-1)
        }
        
        makeTapNoise()
        stage? += 1
    }
    
    func updateAnimation(index:Int){
        if index >= instrImgs.count{
            return
        }
        if (index>0){
            instrImgs[index-1]?.image.removeFromParent()
        }
        if let obj = instrImgs[index]{
            let img = obj.image
            addChild(img)
            let scaleUp = SKAction.scale(by: obj.scaleAmount, duration: 1)
            let scaleDown = SKAction.scale(by: 1/obj.scaleAmount, duration: 1)
            img.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
            if let key = obj.animationKey{
                img.run(SKAction.repeatForever(SKAction.animate(with: obj.textureList!, timePerFrame: obj.timePerFrame!, resize: false, restore: true)), withKey: key)
            }
        }
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
    
    func makeTapNoise(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let soundPath = Bundle.main.path(forResource: "intructionTap", ofType: "wav")
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
