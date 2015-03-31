//
//  GoldFish.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/23/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import SpriteKit

class GoldFish: Fish
{
    
    convenience init()
    {
        self.init(texture: nil, color: UIColor.yellowColor(), size: CGSizeMake(50.0, 15.0))
        pointValue = 50
        
        startingDepthMax = 100

        
        horizontalMaxVector = 300
        horizontalMinVector = 200
        verticalMaxVector = 100
        verticalMinVector = 0
        
        
        minVectorDuration = 1
        maxVectorDuration = 2
        minPauseDuration = 0
        maxPauseDuration = 1
        
    }
    
    
}