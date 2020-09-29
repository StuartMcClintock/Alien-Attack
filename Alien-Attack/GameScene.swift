//
//  GameScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import SpriteKit
import GameplayKit

import AVFoundation
//import AudioToolbox

class AttackingAlien{
    var nodeObject = SKSpriteNode(imageNamed: "greenAlien")
    var minX = 0
    var maxX = 0
    var columnIndex = 0
    var reachedEnd = false
    var destroyed = false
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var del: AppDelegate!
    
    var audioPlayer: AVAudioPlayer?
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    var aliens = [AttackingAlien]()
    var numInColumn = [Int]()
    var numColumns:Int?
    
    var gun:SKSpriteNode?
    var projectile:SKSpriteNode?
    var gunPos:CGPoint?
    var rotationStarted:CFAbsoluteTime?
    
    var alienDest:Int?
    
    let directionTime:TimeInterval = 2
    let gunSpan = 520
    
    var numReachedEnd = 0
    
    var scoreVal = 0{
        didSet{
            scoreLabel.text = "Score: \(scoreVal)"
        }
    }
    var highScoreVal = 0{
        didSet{
            if (del.isBlitz){
                highScoreLabel.text = "Blitz High Score: \(highScoreVal)"
            }
            else{
                highScoreLabel.text = "High Score: \(highScoreVal)"
            }
        }
    }
    
    var waitTime = 0.0
    var waitTimeMultiplier = 0.0
    
    let climbDuration:TimeInterval = 2
    
    // Constants for Standard Mode
    let SWT = 1.4
    let SWTM = 0.99
    
    // Constants for Blitz Mode
    let BWT = 1.0
    let BWTM = 0.98
    
    var gameOver = false
    
    var mercImage: SKSpriteNode!
    
    override func didMove(to view: SKView){
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        del.bottomBanner?.removeFromSuperview()
        if let banner = del.topBanner{
            view.addSubview(banner)
        }
        
        gunPos = CGPoint(x: 100, y: frame.maxY-275)
        alienDest = Int(frame.maxY/20*11)
        numColumns = Int(frame.maxX/del.greenAlienSize.width)
        numInColumn = Array(repeating: 0, count: numColumns!)
        
        if (del.isBlitz){
            waitTime = BWT
            waitTimeMultiplier = BWTM
        }
        else{
            waitTime = SWT
            waitTimeMultiplier = SWTM
        }
        
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.zPosition = -1;
        addChild(background)
        
        
        scoreLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        scoreLabel.text = "Score: 0"
        //scoreLabel.position = CGPoint(x:85, y:30)
        scoreLabel.position = CGPoint(x:45, y:40)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 50
        addChild(scoreLabel)
        
        highScoreLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        var xShift = 255.0
        if (del.highScore > 999){
            xShift = 285.0
        }
        if (del.isBlitz){
            xShift += 80
        }
        highScoreLabel.position = CGPoint(x:frame.maxX-CGFloat(xShift), y:48)
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontSize = 36
        highScoreLabel.fontColor = .black
        addChild(highScoreLabel)
        highScoreVal = del.highScore
        
        initMercImg()
        addGun()
        addAlien()
    }
    
    func initMercImg(){
        mercImage = SKSpriteNode(texture: SKTexture(imageNamed: "mercenaryAlien-clickable"), size: CGSize(width: 120, height: 100))
        mercImage.zPosition = 3
        mercImage.position = CGPoint(x: 60, y: frame.maxY-375)
        mercImage.name = "Merc Button"
        addChild(mercImage)
        updateMercs()
    }
    
    func updateMercs(){
        if del.numMercs == 0{
            mercImage.texture = SKTexture(imageNamed: "mercenaryAlien-notClickable")
            mercImage.alpha = 0.25
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            let name:String = touchedNode.name ?? ""
            if name == "Merc Button"{
                if (!gameOver){
                    mercButtonTapped()
                }
                return
            }
            else{
                fireGun()
            }
        }
    }
    
    func mercButtonTapped(){
        if del.numMercs == 0{
            return
        }
        del.numMercs -= 1
        for i in (0..<aliens.count).reversed(){
            destroyAlien(alien: aliens[i])
            aliens.remove(at: i)
        }
        waitTime = waitTime/(pow(waitTimeMultiplier, 25))
        updateMercs()
    }
    
    func processShot(xPos: Int){
        var removeList:[Int] = []
        for i in 0..<aliens.count{
            if xPos < aliens[i].maxX && xPos > aliens[i].minX{
                destroyAlien(alien: aliens[i])
                removeList.insert(i, at: 0)
            }
        }
        for i in removeList{
            aliens.remove(at: i)
        }
    }
    
    func destroyAlien(alien: AttackingAlien){
        let element = alien.nodeObject
        
        scoreVal += 1
        if scoreVal > highScoreVal{
            highScoreVal = scoreVal
        }
        if alien.reachedEnd{
            numReachedEnd -= 1
        }
        numInColumn[alien.columnIndex] -= 1
        
        if let poof = SKEmitterNode(fileNamed: "Disappear"){
            if !alien.destroyed{
                poof.position = element.position
                addChild(poof)
            }
        }
        element.removeFromParent()
        alien.destroyed = true
        sensoryFeedback()
    }
    
    func sensoryFeedback(){
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        
        if (!del.isMute){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let soundPath = Bundle.main.path(forResource: "alienDestroyed", ofType: "wav")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                audioPlayer?.play()
            }
            catch {}
        }
    }
    
    func addAlien(){
        if (gameOver){
            return
        }
        
        if (whTaken()){
            del.recentScore = scoreVal
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [weak self] in
                self?.endScene()
            })
            return
        }
        
        waitTime *= waitTimeMultiplier
        let columnIndex = Int.random(in: 1..<numColumns!)
        
        let gap = Int(frame.maxX)-numColumns!*Int(del.greenAlienSize.width)
        let startingX = columnIndex*Int(del.greenAlienSize.width)+Int(CGFloat(gap)/2)
        
        let position = CGPoint(x: startingX, y: 0)
        let newAlien = AttackingAlien()
        newAlien.nodeObject.position = position
        newAlien.nodeObject.name = name
        newAlien.nodeObject.size = del.greenAlienSize
        newAlien.nodeObject.name = "badAlien"
        newAlien.maxX = startingX+(Int(del.greenAlienSize.width)/2)
        newAlien.minX = startingX-(Int(del.greenAlienSize.width)/2)
        newAlien.columnIndex = columnIndex
        
        addChild(newAlien.nodeObject)
        aliens.append(newAlien)
        
        newAlien.nodeObject.run(SKAction.move(to: CGPoint(x:startingX, y:alienDest!-numInColumn[columnIndex]*Int(del.greenAlienSize.height)), duration: climbDuration))
        numInColumn[columnIndex] += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + climbDuration, execute: { [weak self] in
            newAlien.reachedEnd = true;
            if !newAlien.destroyed{
                self?.numReachedEnd += 1;
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime, execute: { [weak self] in
            self?.addAlien()
        })
    }
        
    func whTaken() -> Bool{
        let deathNum = 5
        return numReachedEnd >= deathNum
    }
    
    func endScene(){
        UserDefaults.standard.set(del.numMercs, forKey: "numMercs")
        del.topBanner?.removeFromSuperview()
        
        gameOver = true
        del.addGold(score: scoreVal)
        endingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.20, execute: { [weak self] in
            self?.chooseNextScene()
        })
    }
    
    func endingAnimation(){
        endingNoise()
        
        let smilingAlien = SKSpriteNode(imageNamed: "smilingAlien")
        smilingAlien.position = CGPoint(x: frame.midX, y: frame.midY+135)
        smilingAlien.size = CGSize(width: 706, height: 850)
        smilingAlien.alpha = 0.2
        smilingAlien.zPosition = 4
        addChild(smilingAlien)
        
        let fade = SKAction.fadeAlpha(to: 1.0, duration: 4)
        smilingAlien.run(fade)
    }
    
    func endingNoise(){
        if (!del.isMute){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let soundPath = Bundle.main.path(forResource: "lossNoises", ofType: "wav")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                audioPlayer?.play()
                audioPlayer?.setVolume(0, fadeDuration: 4)
            }
            catch {}
        }
    }
    
    func chooseNextScene(){
        if (del.isBlitz && scoreVal >= del.BLITZ_BRONZE_SCORE){
            if (scoreVal >= del.BLITZ_GOLD_SCORE){
                if (!UserDefaults.standard.bool(forKey: "blitzGold")||scoreVal <= del.highScore){
                    goToAwardScene()
                }
                else{
                    goToOverScene()
                }
            }
            else if (scoreVal >= del.BLITZ_SILVER_SCORE){
               if (!UserDefaults.standard.bool(forKey: "blitzSilver")||scoreVal <= del.highScore){
                   goToAwardScene()
               }
               else{
                   goToOverScene()
               }
            }
            else if (scoreVal >= del.BLITZ_BRONZE_SCORE){
                if (!UserDefaults.standard.bool(forKey: "blitzBronze")||scoreVal <= del.highScore){
                    goToAwardScene()
                }
                else{
                    goToOverScene()
                }
            }
        }
        else if (!del.isBlitz && scoreVal >= del.STAN_BRONZE_SCORE){
            if (scoreVal >= del.STAN_GOLD_SCORE){
                if (!UserDefaults.standard.bool(forKey: "standardGold") || scoreVal <= del.highScore){
                    goToAwardScene()
                }
                else{
                    goToOverScene()
                }
            }
            else if (scoreVal >= del.STAN_SILVER_SCORE){
               if (!UserDefaults.standard.bool(forKey: "standardSilver") || scoreVal <= del.highScore){
                   goToAwardScene()
               }
                else{
                    goToOverScene()
                }
            }
            else if (scoreVal >= del.STAN_BRONZE_SCORE){
                if (!UserDefaults.standard.bool(forKey: "standardBronze") || scoreVal <= del.highScore){
                    goToAwardScene()
                }
                else{
                    goToOverScene()
                }
            }
        }
        else{
            goToOverScene()
        }
    }
    
    func goToOverScene(){
        let overScene = GameScene(fileNamed: "GameOverScene")
        overScene?.scaleMode = .fill
        self.view?.presentScene(overScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
    func goToAwardScene(){
        let awardScene = GameScene(fileNamed: "ReceiveAwardScene")
        awardScene?.scaleMode = .aspectFill
        if UIDevice.current.model == "iPad"{
            awardScene?.scaleMode = .fill
        }
        self.view?.presentScene(awardScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
    func addGun(){
        let verticalHeight:CGFloat = 320
        let verticalWidth:CGFloat = 320
        
        gun = SKSpriteNode(imageNamed: "laserGun")
        gun?.size = CGSize(width: verticalHeight, height: verticalWidth)
        gun?.position = gunPos!
        gun?.name = "gun"
        addChild(gun!)
        
        let lrShift = SKAction.repeatForever(SKAction.sequence([SKAction.move(to: CGPoint(x:frame.maxX-100, y:gunPos!.y), duration: directionTime),SKAction.move(to: CGPoint(x:100, y:gunPos!.y), duration: directionTime)]))
        gun?.run(lrShift, withKey:"lrShift")
    }
    
    func fireGun(){
        if gameOver{
            return
        }
        
        let laserPauseTime:TimeInterval = del.regenTime
        
        if gun?.alpha != 1.0{
            return
        }
        gun?.alpha = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + del.regenTime, execute: { [weak self] in
            self?.gun?.alpha = 1.0
        })
        
        
        let rayLength = 1000
        
        projectile = SKSpriteNode(color: SKColor.init(red: 231/255, green: 21/255, blue: 32/255, alpha: 0.4), size: CGSize(width: 30, height: rayLength))
        projectile!.zPosition = 3
        projectile!.position = CGPoint(x: gun!.position.x-6, y:frame.maxY-CGFloat(rayLength/2)-420)
        addChild(projectile!)
        
        gun?.action(forKey: "lrShift")?.speed = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + laserPauseTime, execute: { [weak self] in
            self?.projectile?.removeFromParent();
            self?.gun?.action(forKey: "lrShift")?.speed = 1
        })
        /*DispatchQueue.main.asyncAfter(deadline: .now() + laserPauseTime, execute: { [weak self] in
            self?.gun?.action(forKey: "lrShift")?.speed = 1
        })*/
        
        processShot(xPos: Int(projectile!.position.x))
        
    }
}
