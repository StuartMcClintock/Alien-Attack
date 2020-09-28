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
        del.isMute = UserDefaults.standard.bool(forKey: "isMute")
        
        del.bottomBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //del.bottomBanner!.tag = 1
        del.bottomBanner!.adUnitID = "ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-3234032935918553/6715107738"//
        del.bottomBanner!.rootViewController = self
        del.bottomBanner!.load(GADRequest())
        del.bottomBanner!.frame = CGRect(x: 0, y: view.bounds.height - del.bottomBanner!.frame.size.height, width: del.bottomBanner!.frame.width, height: del.bottomBanner!.frame.height)
        
        del.topBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        del.topBanner!.adUnitID = "ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-3234032935918553/4324748113" //
        del.topBanner!.rootViewController = self
        del.topBanner!.load(GADRequest())
        if UIDevice.current.model == "iPhone" && UIScreen.main.bounds.height > 800{
            del.topBanner!.frame = CGRect(x: 0, y: 30, width: del.topBanner!.frame.width, height: del.topBanner!.frame.height)
        }
        else{
            del.topBanner!.frame = CGRect(x: 0, y: 0, width: del.topBanner!.frame.width, height: del.topBanner!.frame.height)
        }
        
        del.numGold = UserDefaults.standard.integer(forKey: "numGold")
        del.numMercs = UserDefaults.standard.integer(forKey: "numMercs")
        let regenDefault = UserDefaults.standard.double(forKey: "regenTime")
        if regenDefault != 0{
            del.regenTime = regenDefault
        }
        else{
            UserDefaults.standard.setValue(del.regenTime, forKey: "regenTime")
        }
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
