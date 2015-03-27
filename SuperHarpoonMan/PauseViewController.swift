//
//  PauseViewController.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/27/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class PauseViewController: UIViewController
{
    
    

    @IBAction func unpause()
    {
    
        dismissViewControllerAnimated(true, completion: nil)
    
    }

    
    @IBAction func quitGame()
    {
    
        dismissViewControllerAnimated(false, completion: nil)
    
    }

    
    
    
}
