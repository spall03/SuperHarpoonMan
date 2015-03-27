//
//  GameViewController.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        gameScene = GameScene.unarchiveFromFile("GameScene") as? GameScene
            // Configure the view.
            gameView = self.view as SKView
            gameView.showsFPS = true
            gameView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            gameView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            gameScene.size = gameView.bounds.size
            gameScene.scaleMode = .AspectFill
            
            gameView.presentScene(gameScene)

    }

    @IBAction func gameDidPause(sender: UIButton) {
        
        gameScene.paused = true
    }
    
    @IBAction func unwindToGameViewController(segue: UIStoryboardSegue)
    {
        if segue.identifier == "gameResumeSegue"
        {
            gameScene.paused = false
        }
        else
        {
            //GameKitHelper.sharedInstance.saveToLeaderboard(swiftris.score)
            dismissViewControllerAnimated(false, completion: nil)
        }
        
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
