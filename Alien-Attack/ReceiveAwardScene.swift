//
//  AwardScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/7/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class ReceiveAwardScene: SKScene{
    
    var del: AppDelegate!
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        if (del.recentScore > del.highScore){
            del.highScore = del.recentScore
            if (del.isBlitz){
                UserDefaults.standard.set(del.highScore, forKey:"highScore-blitz")
            }
            else{
                UserDefaults.standard.set(del.highScore, forKey:"highScore-standard")
            }
        }
        
        if del.isBlitz{
            if del.recentScore >= del.BLITZ_GOLD_SCORE{
                setImage(mode: "blitz", awardLevel: "Gold")
            }
            else if del.recentScore >= del.BLITZ_SILVER_SCORE{
                setImage(mode: "blitz", awardLevel: "Silver")
            }
            else{
                setImage(mode: "blitz", awardLevel: "Bronze")
            }
        }
        else{
            if del.recentScore >= del.STAN_GOLD_SCORE{
                setImage(mode: "standard", awardLevel: "Gold")
            }
            else if del.recentScore >= del.STAN_SILVER_SCORE{
                setImage(mode: "standard", awardLevel: "Silver")
            }
            else{
                setImage(mode: "standard", awardLevel: "Bronze")
            }
        }
    }

    func setImage(mode: String, awardLevel: String){
        let displayText = SKLabelNode(fontNamed: "DIN Alternate Bold")
        var awardImage: SKSpriteNode!
        if UserDefaults.standard.bool(forKey: mode+awardLevel){
            self.backgroundColor = SKColor.black
            awardImage = SKSpriteNode(imageNamed: "ribon"+awardLevel)
            awardImage.position = CGPoint(x: frame.midX, y: frame.midY)
            awardImage.alpha = 0.25
            displayText.position = CGPoint(x: frame.midX, y: frame.midY)
            displayText.fontSize = 124
            displayText.fontColor = SKColor.white
            displayText.text = "Score:"
            let scoreText = SKLabelNode(fontNamed: "DIN Alternate Bold")
            scoreText.position = CGPoint(x: frame.midX, y: frame.midY-150)
            scoreText.fontSize = 124
            scoreText.fontColor = SKColor.white
            scoreText.text = "\(del.recentScore)"
            addChild(scoreText)
        }
        else{
            self.backgroundColor = SKColor.white
            UserDefaults.standard.set(true, forKey: mode+awardLevel)
            awardImage = SKSpriteNode(imageNamed: mode+awardLevel)
            awardImage.position = CGPoint(x: frame.midX, y: frame.midY+80)
            displayText.position = CGPoint(x:frame.midX, y: 145)
            displayText.zPosition = 2
            displayText.fontSize = 62
            displayText.fontColor = SKColor.black
            displayText.text = "Score of \(del.recentScore)"
            
            let line2 = SKLabelNode(fontNamed: "DIN Alternate Bold")
            line2.text = "\(awardLevel) Medal!"
            line2.position = CGPoint(x:frame.midX, y: 70)
            line2.fontSize = 62
            line2.fontColor = SKColor.black
            addChild(line2)
        }
        
        addChild(awardImage)
        addChild(displayText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func returnToMain(){
        let ogScene = GameScene(fileNamed: "SelectModeScene")
        ogScene?.scaleMode = .aspectFill
        self.view?.presentScene(ogScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
}
