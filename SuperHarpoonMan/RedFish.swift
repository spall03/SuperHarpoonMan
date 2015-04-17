//
//  RedFish.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/19/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import SpriteKit


class RedFish: Fish
{

    convenience init()
    {
        self.init(texture: nil, color: UIColor.redColor(), size: CGSizeMake(100.0, 30.0))
        pointValue = 10
        
        startingDepthMax = 300

        
        horizontalMaxVector = 2000
        horizontalMinVector = 100
        verticalMaxVector = 2000
        verticalMinVector = 100
        
        minVectorDuration = 2
        maxVectorDuration = 4
        minPauseDuration = 2
        maxPauseDuration = 4
        
    }

    
}