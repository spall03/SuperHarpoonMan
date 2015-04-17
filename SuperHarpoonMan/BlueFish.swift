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
        self.init(texture: nil, color: UIColor.blueColor(), size: CGSizeMake(100.0, 35.0))
        pointValue = 20
        
        startingDepthMax = 200

        
        horizontalMaxVector = 250
        horizontalMinVector = 150
        verticalMaxVector = 300
        verticalMinVector = 150
        
        minVectorDuration = 1
        maxVectorDuration = 3
        minPauseDuration = 1
        maxPauseDuration = 3
        
    }
    
    
}