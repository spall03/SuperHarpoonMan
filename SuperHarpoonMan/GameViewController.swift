//
//  GameViewController.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import UIKit
import SpriteKit

let superHarpoonManGameIsOver = "super_harpoon_man_game_is_over"

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            
            var sceneData: NSData?
            do {
                sceneData = try  NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            } catch _ as NSError {
                
            }
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameDidEnd", name:superHarpoonManGameIsOver, object: nil)

        gameScene = GameScene.unarchiveFromFile("GameScene") as? GameScene
            // Configure the view.
            gameView = self.view as! SKView
            gameView.showsFPS = true
            gameView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            gameView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            gameScene.size = gameView.bounds.size
            gameScene.scaleMode = .AspectFill
            
            gameView.presentScene(gameScene)

    }
    
    func gameDidEnd()
    {
        view.userInteractionEnabled = false
        
        
        let endGameAlertViewController = UIAlertController(title: "Game Over!", message: "Congrats! You scored \(gameScene.score)", preferredStyle: UIAlertControllerStyle.Alert)
        let endGameOKButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            

            self.performSegueWithIdentifier("endGameSegue", sender: self)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        endGameAlertViewController.addAction(endGameOKButton)
        
        presentViewController(endGameAlertViewController, animated: true, completion: nil)
        
        
        
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
            GameKitHelper.sharedInstance.saveToLeaderboard(gameScene.score)
            dismissViewControllerAnimated(false, completion: nil)
        }
        
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
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
