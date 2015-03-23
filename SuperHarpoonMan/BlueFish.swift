//
//  BlueFish.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/19/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import SpriteKit

class BlueFish: Fish
{
    
    convenience init()
    {
        self.init(texture: nil, color: UIColor.blueColor(), size: CGSizeMake(10.0, 5.0))
        pointValue = 20
        
        startingDepthMax = 10
        startingDepthMin = -25
        
        horizontalMaxVector = 20
        horizontalMinVector = 5
        verticalMaxVector = 10
        verticalMinVector = 0
        
        minVectorDuration = 1
        maxVectorDuration = 3
        minPauseDuration = 1
        maxPauseDuration = 3
        
    }
    
    
}