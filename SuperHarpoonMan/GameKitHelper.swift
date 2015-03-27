//
//  GameKitHelper.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/2/15.
//  Copyright (c) 2015 SJP. All rights reserved.
//

import Foundation
import GameKit

let SPPresentAuthenticationViewController = "present_authentication_view_controller"

private let singletonInstance = GameKitHelper()

class GameKitHelper: NSObject, GKGameCenterControllerDelegate
{
    
    
    var authenticationViewController: UIViewController!
    var lastError: NSError?
    var enableGameCenter: Bool = true

    class var sharedInstance: GameKitHelper
    {
            return singletonInstance
    }
    
    
    func authenticateLocalPlayer()
    {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(vc:UIViewController!, error:NSError?) -> Void in
            
            self.lastError = error
            
            if (vc != nil)
            {
                self.authenticationViewController = vc
                NSNotificationCenter.defaultCenter().postNotificationName(SPPresentAuthenticationViewController, object: self)
                
            }
            else if (localPlayer.authenticated)
            {
                self.enableGameCenter = true
            
            
            }
            else
            {
                self.enableGameCenter = false
                
            }
        
        
        
        }
    }
    
    //saves a high score to a Game Center leaderboard
    func saveToLeaderboard(score: Int)
    {
        
        if GKLocalPlayer.localPlayer().authenticated
        {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "SJPSwiftrisHighScores")
            scoreReporter.value = Int64(score)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: { (error: NSError!) -> Void in
                
                if error != nil
                {
                        print("Score upload to Game Center didn't work.")
                }
            })
            
        }
        
    }
    
    func reportAchievement(identifier:String, percentComplete:Double)
    {
        
        if GKLocalPlayer.localPlayer().authenticated
        {
        
            let achievement = GKAchievement(identifier: identifier)
            achievement.percentComplete = percentComplete
            achievement.showsCompletionBanner = true
            
            let achievementArray: [GKAchievement] = [achievement]
            
            GKAchievement.reportAchievements(achievementArray, withCompletionHandler: { (error:NSError!) -> Void in
                if error != nil
                {
                    print("Achievement upload to Game Center didn't work.")
                }
            })
       
        }
        
    }
    
    //shows leaderboard screen
    func showLeaderboard(viewController: UIViewController)
    {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}