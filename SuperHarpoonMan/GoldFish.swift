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
        self.init(texture: nil, color: UIColor.yellowColor(), size: CGSizeMake(6.0, 2.0))
        pointValue = 50
        
        startingDepthMax = -10
        startingDepthMin = -30
        
        horizontalMaxVector = 20
        horizontalMinVector = 10
        verticalMaxVector = 3
        verticalMinVector = 0
        
        
        minVectorDuration = 1
        maxVectorDuration = 1
        minPauseDuration = 0
        maxPauseDuration = 1
        
    }
    
    
}