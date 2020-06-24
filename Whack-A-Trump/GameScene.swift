//
//  GameScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //var del: AppDelegate!
    
    var scoreLabel: SKLabelNode!
    var faces = [SKSpriteNode]()
    
    var scoreVal = 0{
        didSet{
            scoreLabel.text = "Score: \(scoreVal)"
        }
    }
    
    var waitTime = 1.0
    
    var totalVisible = 0
    
    override func didMove(to view: SKView){
        let background = SKSpriteNode(imageNamed: "whitehouse")
        background.position = CGPoint(x:frame.midX, y:frame.midY)
        background.blendMode = .replace
        background.zPosition = -1;
        addChild(background)
        
        
        scoreLabel = SKLabelNode(fontNamed: "rockwell")
        scoreLabel.text = "Score: 0"
        //scoreLabel.position = CGPoint(x:85, y:30)
        scoreLabel.position = CGPoint(x:35, y:30)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
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
            faces[col+row*6].alpha = 0
            totalVisible -= 1
        }
    }
    
    func dispFaces(){
        waitTime *= 0.98
        
        let dispNum = Int.random(in: 0..<30)
        faces[dispNum].alpha = 1
        totalVisible += 1
        
        if (totalVisible >= 5){
            let overScene = GameOverScene(fileNamed: "GameOverScene")
            overScene?.scaleMode = .aspectFill
            self.view?.presentScene(overScene!, transition: .flipVertical(withDuration: 0.5))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime, execute: { [weak self] in
            self?.dispFaces()
        })
    }
}
