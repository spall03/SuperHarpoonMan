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
        self.init(texture: nil, color: UIColor.redColor(), size: CGSizeMake(10.0, 5.0))
        pointValue = 10
        
        startingDepthMax = 20
        startingDepthMin = -20
        
        horizontalMaxVector = 10
        verticalMaxVector = 5
        minVectorDuration = 2
        maxVectorDuration = 4
        minPauseDuration = 2
        maxPauseDuration = 4
        
    }

    
}