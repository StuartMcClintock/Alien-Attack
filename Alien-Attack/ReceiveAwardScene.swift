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
        
        displayGold(alreadyHad: UserDefaults.standard.bool(forKey: mode+awardLevel))
        
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
        
        awardImage.zPosition = -1
        addChild(awardImage)
        addChild(displayText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        returnToMain()
    }
    
    func displayGold(alreadyHad:Bool){
        var offsetY:CGFloat = 160
        var offsetX:CGFloat = 0
        var coinDist:CGFloat = 70
        var coinSize = 75
        
        if alreadyHad{
            offsetY = 135
            offsetX = 0
            coinDist = 70
            coinSize = 75
            let goldLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let labelText = formatter.string(from: NSNumber(value:del.addedGold))
            goldLabel.horizontalAlignmentMode = .left
            goldLabel.verticalAlignmentMode = .center
            goldLabel.text = labelText
            goldLabel.position = CGPoint(x: frame.midX+(coinDist/2)-offsetX, y: offsetY)
            goldLabel.fontColor = SKColor.white
            goldLabel.fontSize = 76
            addChild(goldLabel)
        }
        
        let goldImage = SKSpriteNode(texture: del.coinFrames[0])
        if alreadyHad{
            goldImage.position = CGPoint(x:frame.midX-(coinDist/2)-offsetX, y:offsetY)
        }
        else{
            goldImage.position = CGPoint(x:frame.midX-(coinDist/2)-offsetX, y:frame.maxY-offsetY)
        }
        goldImage.size = CGSize(width: coinSize, height: coinSize)
        addChild(goldImage)
        goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        self.view?.presentScene(modeScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
}
