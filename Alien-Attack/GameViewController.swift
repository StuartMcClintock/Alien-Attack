//
//  GameViewController.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var del: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        del = UIApplication.shared.delegate as? AppDelegate
        
        del.adBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        del.adBanner!.tag = 1
        del.adBanner!.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        del.adBanner!.rootViewController = self
        del.adBanner!.load(GADRequest())
        del.adBanner!.frame = CGRect(x: 0, y: view.bounds.height - del.adBanner!.frame.size.height, width: del.adBanner!.frame.width, height: del.adBanner!.frame.height)
        
        del.numGold = UserDefaults.standard.integer(forKey: "numGold")
        del.numMercs = UserDefaults.standard.integer(forKey: "numMercs")
        del.buildCoinFrames()
        
        
        print(UIScreen.main.bounds)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "IntroScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if UIDevice.current.model == "iPad"{
                    scene.scaleMode = .fill
                }
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
