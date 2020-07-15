//
//  AwardDisplayScene.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 7/12/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class AwardDisplayScene: SKScene{
    var del: AppDelegate!
    
    var blitzBronze: SKSpriteNode!
    var blitzSilver: SKSpriteNode!
    var blitzGold: SKSpriteNode!
    var standardBronze: SKSpriteNode!
    var standardSilver: SKSpriteNode!
    var standardGold: SKSpriteNode!
    
    var scoreLabels: [SKLabelNode]!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        /*let blitzBronzeText = "\(del.BLITZ_BRONZE_SCORE)-\(del.BLITZ_SILVER_SCORE-1) pts"
        let blitzSilverText = "\(del.BLITZ_SILVER_SCORE)-\(del.BLITZ_GOLD_SCORE-1) pts"
        let blitzGoldText = "\(del.BLITZ_GOLD_SCORE)+ pts"*/
        
        self.backgroundColor = SKColor.white
        initImages()
        initScoreLabels()
        addStandardAwards()
        addBlitzAwards()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        let ogScene = GameScene(fileNamed: "SelectModeScene")
        ogScene?.scaleMode = .aspectFill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
    func initImages(){
        let WIDTH = 220
        let HEIGHT = 400
        blitzBronze = SKSpriteNode(imageNamed: "blitzBronze")
        blitzBronze.size = CGSize(width: WIDTH, height: HEIGHT)
        blitzSilver = SKSpriteNode(imageNamed: "blitzSilver")
        blitzSilver.size = CGSize(width: WIDTH, height: HEIGHT)
        blitzGold = SKSpriteNode(imageNamed: "blitzGold")
        blitzGold.size = CGSize(width: WIDTH, height: HEIGHT)
        standardBronze = SKSpriteNode(imageNamed: "standardBronze")
        standardBronze.size = CGSize(width: WIDTH, height: HEIGHT)
        standardSilver = SKSpriteNode(imageNamed: "standardSilver")
        standardSilver.size = CGSize(width: WIDTH, height: HEIGHT)
        standardGold = SKSpriteNode(imageNamed: "standardGold")
        standardGold.size = CGSize(width: WIDTH, height: HEIGHT)
    }
    
    func initScoreLabels(){
        scoreLabels = []
        scoreLabels.append(SKLabelNode(text: "\(del.STAN_BRONZE_SCORE)-\(del.STAN_SILVER_SCORE-1) pts"))
        scoreLabels.append(SKLabelNode(text: "\(del.STAN_SILVER_SCORE)-\(del.STAN_GOLD_SCORE-1) pts"))
        scoreLabels.append(SKLabelNode(text: "\(del.STAN_GOLD_SCORE)+ pts"))
        scoreLabels.append(SKLabelNode(text: "\(del.BLITZ_BRONZE_SCORE)-\(del.BLITZ_SILVER_SCORE-1) pts"))
        scoreLabels.append(SKLabelNode(text: "\(del.BLITZ_SILVER_SCORE)-\(del.BLITZ_GOLD_SCORE-1) pts"))
        scoreLabels.append(SKLabelNode(text: "\(del.BLITZ_GOLD_SCORE)+ pts"))
        
        for label in scoreLabels{
            label.fontName = "DIN Alternate Bold"
            label.fontColor = SKColor.black
            label.fontSize = 36
        }
    }
    
    func addStandardAwards(){
        let standardLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        standardLabel.fontSize = 72
        standardLabel.text = "Standard Mode:"
        standardLabel.fontColor = SKColor.black
        standardLabel.position = CGPoint(x:frame.midX, y: frame.maxY-145)
        addChild(standardLabel)
        standardBronze.position = CGPoint(x: 130, y: frame.maxY-390)
        scoreLabels[0].position = CGPoint(x: 130, y: frame.maxY-640)
        standardSilver.position = CGPoint(x: 375, y: frame.maxY-390)
        scoreLabels[1].position = CGPoint(x: 375, y: frame.maxY-640)
        standardGold.position = CGPoint(x: 620, y: frame.maxY-390)
        scoreLabels[2].position = CGPoint(x: 620, y: frame.maxY-640)
        addChild(standardBronze)
        addChild(standardSilver)
        addChild(standardGold)
        addChild(scoreLabels[0])
        addChild(scoreLabels[1])
        addChild(scoreLabels[2])
    }
    
    func addBlitzAwards(){
        let blitzLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        blitzLabel.fontSize = 72
        blitzLabel.text = "Blitz Mode:"
        blitzLabel.fontColor = SKColor.black
        blitzLabel.position = CGPoint(x:frame.midX, y: frame.maxY-755)
        addChild(blitzLabel)
        blitzBronze.position = CGPoint(x: 130, y: frame.maxY-1000)
        scoreLabels[3].position = CGPoint(x: 130, y: frame.maxY-1250)
        blitzSilver.position = CGPoint(x: 375, y: frame.maxY-1000)
        scoreLabels[4].position = CGPoint(x: 375, y: frame.maxY-1250)
        blitzGold.position = CGPoint(x: 620, y: frame.maxY-1000)
        scoreLabels[5].position = CGPoint(x: 620, y: frame.maxY-1250)
        addChild(blitzBronze)
        addChild(blitzSilver)
        addChild(blitzGold)
        addChild(scoreLabels[3])
        addChild(scoreLabels[4])
        addChild(scoreLabels[5])
    }
}
