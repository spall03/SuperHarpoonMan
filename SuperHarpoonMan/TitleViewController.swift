//
//  TitleViewController.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/27/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import UIKit


class TitleViewController: UIViewController
{
    
    override func viewDidAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticationViewController", name: SPPresentAuthenticationViewController, object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
    }
    
    @IBAction func showHighScores()
    {
          GameKitHelper.sharedInstance.showLeaderboard(self)
        
    }
    
    func showAuthenticationViewController()
    {
        
        self.presentViewController(GameKitHelper.sharedInstance.authenticationViewController, animated: true, completion: nil)
        
        
    }
    

    
    @IBAction func unwindToTitleViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    
}
