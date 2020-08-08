//
//  AwardDisplayScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/12/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class AwardDisplayScene: SKScene{
    var del: AppDelegate!
    
    var awardImages: [SKSpriteNode]!
    var scoreLabels: [SKLabelNode]!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        initImages()
        initScoreLabels()
        addAwards()
        reflectAchievement()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        if UIDevice.current.model == "iPad"{
            modeScene?.scaleMode = .fill
        }
        self.view?.presentScene(modeScene!, transition: .doorsCloseVertical(withDuration: 0.4))
    }
    
    func initImages(){
        let WIDTH = 220
        let HEIGHT = 400
        
        awardImages = []
        awardImages.append(SKSpriteNode(imageNamed: "standardBronze"))
        awardImages.append(SKSpriteNode(imageNamed: "standardSilver"))
        awardImages.append(SKSpriteNode(imageNamed: "standardGold"))
        awardImages.append(SKSpriteNode(imageNamed: "blitzBronze"))
        awardImages.append(SKSpriteNode(imageNamed: "blitzSilver"))
        awardImages.append(SKSpriteNode(imageNamed: "blitzGold"))
        
        for img in awardImages{
            img.size = CGSize(width: WIDTH, height: HEIGHT)
        }
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
    
    func addAwards(){
        var yShift:CGFloat = 0
        if UIDevice.current.model == "iPhone" && UIScreen.main.bounds.height > 800{
            yShift = 20
        }
        
        let standardLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        standardLabel.fontSize = 72
        standardLabel.text = "Standard Mode:"
        standardLabel.fontColor = SKColor.black
        standardLabel.position = CGPoint(x:frame.midX, y: frame.maxY-105-yShift)
        addChild(standardLabel)
        
        let blitzLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        blitzLabel.fontSize = 72
        blitzLabel.text = "Blitz Mode:"
        blitzLabel.fontColor = SKColor.black
        blitzLabel.position = CGPoint(x:frame.midX, y: frame.maxY-720-yShift)
        addChild(blitzLabel)
        
        awardImages[0].position = CGPoint(x: 130, y: frame.maxY-350-yShift)
        scoreLabels[0].position = CGPoint(x: 130, y: frame.maxY-600-yShift)
        awardImages[1].position = CGPoint(x: 375, y: frame.maxY-350-yShift)
        scoreLabels[1].position = CGPoint(x: 375, y: frame.maxY-600-yShift)
        awardImages[2].position = CGPoint(x: 620, y: frame.maxY-350-yShift)
        scoreLabels[2].position = CGPoint(x: 620, y: frame.maxY-600-yShift)
        awardImages[3].position = CGPoint(x: 130, y: frame.maxY-960-yShift)
        scoreLabels[3].position = CGPoint(x: 130, y: frame.maxY-1210-yShift)
        awardImages[4].position = CGPoint(x: 375, y: frame.maxY-960-yShift)
        scoreLabels[4].position = CGPoint(x: 375, y: frame.maxY-1210-yShift)
        awardImages[5].position = CGPoint(x: 620, y: frame.maxY-960-yShift)
        scoreLabels[5].position = CGPoint(x: 620, y: frame.maxY-1210-yShift)
        for i in 0..<awardImages.count{
            addChild(awardImages[i])
            addChild(scoreLabels[i])
        }
    }
    
    func reflectAchievement(){
        let awardsReceived = [
        UserDefaults.standard.bool(forKey: "standardBronze"),
        UserDefaults.standard.bool(forKey: "standardSilver"),
        UserDefaults.standard.bool(forKey: "standardGold"),
        UserDefaults.standard.bool(forKey: "blitzBronze"),
        UserDefaults.standard.bool(forKey: "blitzSilver"),
        UserDefaults.standard.bool(forKey: "blitzGold")]
        
        for i in 0..<awardsReceived.count{
            if !awardsReceived[i]{
                awardImages[i].alpha = 0.3
                scoreLabels[i].alpha = 0.5
            }
        }
    }
}
