//
//  AppDelegate.swift
//  Alien-Attack
//
//  Created by Stuart McClintock on 5/5/20.
//  Copyright © 2020 Stuart McClintock. All rights reserved.
//

import UIKit

import AVFoundation
import SpriteKit

import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var recentScore: Int = 0
    var highScore: Int = 0
    var numGold: Int = 0
    var numMercs: Int = 0
    
    var isBlitz: Bool = false
    var isMute: Bool = false

    var audioPlayer: AVAudioPlayer?
    
    // Define Award Constants
    let BLITZ_BRONZE_SCORE = 30
    let BLITZ_SILVER_SCORE = 75
    let BLITZ_GOLD_SCORE = 150
    
    let STAN_BRONZE_SCORE = 20
    let STAN_SILVER_SCORE = 250
    let STAN_GOLD_SCORE = 500
    
    let BRONZE_BONUS = 1000
    let SILVER_BONUS = 10000
    let GOLD_BONUS = 100000
    
    func buttonSound(){
        if !isMute{
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let soundPath = Bundle.main.path(forResource: "buttonNoise", ofType: "wav")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
                audioPlayer?.play()
            }
            catch {}
        }
    }
    
    
    var addedGold = 0
    
    func addGold(score: Int){
        if isBlitz{
            addedGold = Int(score/5)
        }
        else{
            addedGold = Int(score/10)
        }
        numGold += addedGold
        UserDefaults.standard.set(numGold, forKey: "numGold")
    }
    
    var coinFrames: [SKTexture] = []
    
    func buildCoinFrames(){
        let coinAnimatedAtlas = SKTextureAtlas(named: "Coins3")
        var frames: [SKTexture] = []
        for i in 0..<coinAnimatedAtlas.textureNames.count{
            frames.append(coinAnimatedAtlas.textureNamed("coin\(i)"))
        }
        coinFrames = frames
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

