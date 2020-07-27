//
//  StoreScene.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 7/24/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene{
    
    var del: AppDelegate!
    
    enum listingType{
        case mercenary
    }
    
    class Listing{
        var type:listingType = .mercenary
        var goldRequired = 0
        var mercenariesReceived = 0
    }
    
    var listings:[Listing] = []
    
    override func didMove(to view: SKView) {
        let app = UIApplication.shared
        del = app.delegate as? AppDelegate
        
        self.backgroundColor = SKColor.white
        addBackButton()
        createListings()
        drawListings()
    }
    
    func createListings(){
        let listing1 = Listing()
        listing1.goldRequired = 500
        listing1.mercenariesReceived = 1
        listings.append(listing1)
        
        let listing2 = Listing()
        listing2.goldRequired = 2000
        listing2.mercenariesReceived = 5
        listings.append(listing2)
    }
    
    func drawListings(){
        let gapSpace:CGFloat = 150
        var yOffset = gapSpace+30
        
        var rowNum = 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        for curr in listings{
            let endLine = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: frame.maxY-yOffset))
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY-yOffset))
            endLine.path = path
            endLine.strokeColor = SKColor.black
            endLine.lineWidth = 3
            addChild(endLine)
            
            let buyButton = SKSpriteNode()
            buyButton.size = CGSize(width: 130, height: 75)
            if del.numGold >= curr.goldRequired{
                buyButton.color = SKColor.white
            }
            else{
                buyButton.color = SKColor.darkGray
            }
            buyButton.position = CGPoint(x: frame.maxX-90, y: frame.maxY-yOffset+(gapSpace/2))
            addChild(buyButton)
            let buyText = SKLabelNode(fontNamed: "DIN Alternate Bold")
            buyText.color = SKColor.white
            buyText.verticalAlignmentMode = .center
            buyText.position = CGPoint(x: frame.maxX-90, y: frame.maxY-yOffset+(gapSpace/2))
            buyText.text = "BUY"
            buyText.fontSize = 52
            buyText.name = "BUY\(rowNum)"
            addChild(buyText)
            
            
            
            
            let mercImage = SKSpriteNode(imageNamed: "mercenaryAlien-black")
            mercImage.size = CGSize(width: 100, height: 100)
            mercImage.position = CGPoint(x: 80, y: frame.maxY-yOffset+(gapSpace/2))
            addChild(mercImage)
            let mercLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
            mercLabel.fontSize = 72
            mercLabel.fontColor = SKColor.black
            mercLabel.horizontalAlignmentMode = .left
            mercLabel.verticalAlignmentMode = .center
            mercLabel.position = CGPoint(x: 175, y: frame.maxY-yOffset+(gapSpace/2))
            mercLabel.text = "\(curr.mercenariesReceived)"
            addChild(mercLabel)
            
            let goldImage = SKSpriteNode(texture: del.coinFrames[0])
            goldImage.position = CGPoint(x: 290, y: frame.maxY-yOffset+(gapSpace/2))
            goldImage.size = CGSize(width:65, height:65)
            addChild(goldImage)
            goldImage.run(SKAction.repeatForever(SKAction.animate(with: del.coinFrames, timePerFrame: 0.04, resize: false, restore: true)), withKey: "rotatingCoin")
            
            let labelText = formatter.string(from: NSNumber(value:curr.goldRequired))
            let goldLabel = SKLabelNode(fontNamed: "DIN Alternate Bold")
            goldLabel.fontSize = 54
            goldLabel.fontColor = SKColor.black
            goldLabel.horizontalAlignmentMode = .left
            goldLabel.verticalAlignmentMode = .center
            goldLabel.position = CGPoint(x: 340, y: frame.maxY-yOffset+(gapSpace/2))
            goldLabel.text = labelText
            addChild(goldLabel)
            
            
            yOffset += gapSpace
            rowNum += 1
        }
    }
    
    func addBackButton(){
        let pos = CGPoint(x:frame.midX, y:120)
        
        let button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 300, height: 100))
        button.name = "back"
        button.position = pos
        let buttonText = SKLabelNode(fontNamed: "DIN Alternate Bold")
        buttonText.text = "BACK"
        buttonText.name = "back"
        buttonText.fontSize = 62
        buttonText.color = SKColor.white
        buttonText.position = CGPoint(x:pos.x, y:pos.y-25.0)
        addChild(button)
        addChild(buttonText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchedNode = atPoint(touch.location(in: self))
            if touchedNode.name == "back"{
                returnToMain()
            }
            
        }
    }
    
    func returnToMain(){
        del.buttonSound()
        
        let modeScene = GameScene(fileNamed: "SelectModeScene")
        modeScene?.scaleMode = .aspectFill
        self.view?.presentScene(modeScene!, transition: .doorsCloseVertical(withDuration: 0.4))
    }
}
