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
        
        var yShift:CGFloat = 0
        if UIDevice.current.model == "iPhone" && UIScreen.main.bounds.height > 800{
            yShift = 30
        }
        
        displayGold(alreadyHad: UserDefaults.standard.bool(forKey: mode+awardLevel))
        
        if UserDefaults.standard.bool(forKey: mode+awardLevel){
            self.backgroundColor = SKColor.black
            awardImage = SKSpriteNode(imageNamed: "ribon"+awardLevel)
            awardImage.position = CGPoint(x: frame.midX, y: frame.midY+15)
            awardImage.alpha = 0.25
            displayText.position = CGPoint(x: frame.midX, y: frame.midY+15)
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
            awardImage.position = CGPoint(x: frame.midX, y: frame.midY+140-yShift)
            displayText.position = CGPoint(x:frame.midX, y: 210)
            displayText.zPosition = 2
            displayText.fontSize = 66
            displayText.fontColor = SKColor.black
            displayText.text = "Score of \(del.recentScore)"
            
            let line2 = SKLabelNode(fontNamed: "DIN Alternate Bold")
            line2.text = "\(awardLevel) Medal!"
            line2.position = CGPoint(x:frame.midX, y: 55)
            line2.fontSize = 66
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
        var offsetY:CGFloat = 155
        var offsetX:CGFloat = 0
        var coinDist:CGFloat = 45
        var coinSize = 55
        var labelFontSize:CGFloat = 62
        var labelColor = SKColor.black
        
        if alreadyHad{
            offsetY = 135
            offsetX = 0
            coinDist = 70
            coinSize = 75
            labelFontSize = 76
            labelColor = SKColor.white
        }
        else{
            addBonus()
        }
        
        if del.addedGold >= 10{
            offsetX += CGFloat((String(del.addedGold).count-1)*25)
        }
        
        let goldLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let labelText = formatter.string(from: NSNumber(value:del.addedGold))
        goldLabel.horizontalAlignmentMode = .left
        goldLabel.verticalAlignmentMode = .center
        goldLabel.text = labelText
        goldLabel.position = CGPoint(x: frame.midX+(coinDist/2)-offsetX, y: offsetY)
        goldLabel.fontColor = labelColor
        goldLabel.fontSize = labelFontSize
        addChild(goldLabel)
        
        let goldImage = SKSpriteNode(texture: del.coinFrames[0])
        goldImage.position = CGPoint(x:frame.midX-(coinDist/2)-offsetX, y:offsetY)
        goldImage.size = CGSize(width: coinSize, height: coinSize)
        addChild(goldImage)
        goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
    }
    
    func addBonus(){
        if !del.isBlitz && del.recentScore >= del.STAN_GOLD_SCORE{
            del.addedGold += del.GOLD_BONUS
            del.numGold += del.GOLD_BONUS
        }
        else if del.isBlitz && del.recentScore >= del.BLITZ_GOLD_SCORE{
            del.addedGold += del.GOLD_BONUS
            del.numGold += del.GOLD_BONUS
        }
        else if !del.isBlitz && del.recentScore >= del.STAN_SILVER_SCORE{
            del.addedGold += del.SILVER_BONUS
            del.numGold += del.SILVER_BONUS
        }
        else if del.isBlitz && del.recentScore >= del.BLITZ_SILVER_SCORE{
            del.addedGold += del.SILVER_BONUS
            del.numGold += del.SILVER_BONUS
        }
        else if !del.isBlitz && del.recentScore >= del.STAN_BRONZE_SCORE{
            del.addedGold += del.BRONZE_BONUS
            del.numGold += del.BRONZE_BONUS
        }
        else if del.isBlitz && del.recentScore >= del.BLITZ_BRONZE_SCORE{
            del.addedGold += del.BRONZE_BONUS
            del.numGold += del.BRONZE_BONUS
        }
        
        UserDefaults.standard.set(del.numGold, forKey: "numGold")
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        if UIDevice.current.model == "iPad"{
            modeScene?.scaleMode = .fill
        }
        self.view?.presentScene(modeScene!, transition: .flipVertical(withDuration: 0.5))
    }
    
}
