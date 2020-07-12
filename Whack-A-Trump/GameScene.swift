//
//  GameScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import SpriteKit
import GameplayKit

import AVFoundation
//import AudioToolbox

class GameScene: SKScene {
    var del: AppDelegate!
    
    var audioPlayer: AVAudioPlayer?
    
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    var faces = [SKSpriteNode]()
    
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
    
    let MAX_FACES = 5
    
    var waitTime = 0.0
    var waitTimeMultiplier = 0.0
    
    // Constants for Standard Mode
    let SWT = 0.75
    let SWTM = 0.992
    
    // Constants for Blitz Mode
    let BWT = 0.4
    let BWTM = 0.965
    
    var totalVisible = 0
    //let visibleLock = NSLock()
    
    var gameOver = false
    
    
    override func didMove(to view: SKView){
        
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
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
        
        let gapX = (frame.maxX)/5
        let gapY = (frame.midY)/6
        
        for row in 0..<5 {
            for col in 0..<6 {
                addFace(at: CGPoint(x:70+Int(gapX*CGFloat(row)), y:Int(frame.midY)-Int(CGFloat(col)*gapY)+30), name:String(col)+","+String(row))
            }
        }
        
        dispFaces()
    }
    
    func addFace(at position: CGPoint, name:String){
        let newFace = SKSpriteNode(imageNamed: "trump")
        newFace.position = position
        newFace.zPosition = 1
        newFace.alpha = 0
        newFace.name = name
        addChild(newFace)
        faces.append(newFace)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches[touches.startIndex] as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.nodes(at: positionInScene)
        
        
        let description = touchedNode.description
        let name = description.components(separatedBy: " ")[1]
        let coords = name.components(separatedBy: "'")[1]
        let splitCoords = coords.components(separatedBy: ",")
        
        let col = splitCoords[0]
        if (col == "(null)"){
            return
        }
        let row = splitCoords[1]
        processTap(col: Int(col)!, row: Int(row)!)
    }
    
    func processTap(col: Int, row: Int){
        if (faces[col+row*6].alpha == 1){
            scoreVal += 1
            if (scoreVal > highScoreVal){
                highScoreVal = scoreVal
                highScoreLabel.fontColor = .init(displayP3Red: 160/255, green: 0, blue: 0, alpha: 1)
            }
            totalVisible -= 1
            
            faces[col+row*6].alpha = 0
            if let poof = SKEmitterNode(fileNamed: "Disappear"){
                poof.position = faces[col+row*6].position
                addChild(poof)
            }
            
            sensoryFeedback()
        }
    }
    
    func sensoryFeedback(){
        //AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        do{
            let soundPath = Bundle.main.path(forResource: "pop", ofType: "wav")
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
            audioPlayer?.play()
        }
        catch {}
    }
    
    func dispFaces(){
        if (gameOver){
            return
        }
        waitTime *= waitTimeMultiplier
        
        var dispNum = Int.random(in: 0..<30)
        while (faces[dispNum].alpha == 1){
            dispNum = Int.random(in: 0..<30)
        }
        
        faces[dispNum].alpha = 1
        totalVisible += 1
        
        if (totalVisible >= MAX_FACES){
            gameOver = true
            del.recentScore = scoreVal
            
            //endScene()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
                self?.endScene()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime, execute: { [weak self] in
            self?.dispFaces()
        })
    }
    
    func endScene(){
        if (totalVisible >= MAX_FACES){
            let overScene = GameOverScene(fileNamed: "GameOverScene")
            overScene?.scaleMode = .fill
            self.view?.presentScene(overScene!, transition: .flipVertical(withDuration: 0.5))
        }
        else{
            gameOver = false
            dispFaces()
        }
    }
}
