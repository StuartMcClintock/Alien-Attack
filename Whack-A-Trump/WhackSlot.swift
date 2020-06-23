//
//  WhackSlot.swift
//  Whack-A-Trump
//
//  Created by Stuart McClintock on 6/22/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    func configure(at position: CGPoint){
        print("bruhhhh")
        let blah = SKSpriteNode(imageNamed: "trump")
        blah.position = position
        blah.zPosition = 1
        addChild(blah)
        
        /*var charNode: SKSpriteNode!
        
        self.position = position
        
        let sprite = SKSpriteNode()
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = nil
        
        charNode = SKSpriteNode(imageNamed: "trump")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)*/
        
    }
}
