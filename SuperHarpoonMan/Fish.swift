//
//  Fish.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/18/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import SpriteKit

class Fish: SKSpriteNode
{
    
    var pointValue: Int = 0
    var swimVector: CGVector!
//    var fishIndex: Int = 0
    
    var startingDepthMax: CGFloat!

    
    var horizontalMaxVector: CGFloat!
    var horizontalMinVector: CGFloat!
    var verticalMaxVector: CGFloat!
    var verticalMinVector: CGFloat!

    
    var minVectorDuration: CGFloat!
    var maxVectorDuration: CGFloat!
    var minPauseDuration: CGFloat!
    var maxPauseDuration: CGFloat!
    
    var horizontalRange: SKRange!
    var verticalRange: SKRange!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.name = "fish"
        
    }
    
    
    func setupFish()
    {

        let screenWidth = self.scene?.view?.frame.width
        let screenHeight = self.scene?.view?.frame.height
        let midScreen = CGPointMake(screenWidth! / 2, screenHeight! / 2)
       
        //assign the fish a random starting position in the water
        
        self.position.x = random(midScreen.x - 150, max: midScreen.x + 150)
        self.position.y = random(midScreen.y, max: startingDepthMax)
    
        
        //define the fish's movement range
        horizontalRange = SKRange(lowerLimit: 0, upperLimit: 375)
        verticalRange = SKRange(lowerLimit: 0, upperLimit: 450)
        
        let movementBox = SKConstraint.positionX(horizontalRange, y: verticalRange)
        self.constraints = [movementBox]
        
        //set up fish physics
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.dynamic = true
        self.physicsBody!.pinned = false
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        
        //set up fish collision detection
        self.physicsBody!.categoryBitMask = PhysicsCategory.Fish
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
        self.physicsBody!.contactTestBitMask = PhysicsCategory.HarpoonTip | PhysicsCategory.WaterEdge
        
        
    }
    
    func moveFish()
    {
        let duration = NSTimeInterval(random(minVectorDuration, max: maxVectorDuration))
        var dx = random((-horizontalMaxVector), max: (horizontalMaxVector))
        var dy = random((-verticalMaxVector), max: (verticalMaxVector))
        
        
        //minimum vector checks for positive and negative horizontal and vertical components
        if (dx < horizontalMinVector && dx > 0)
        {
            dx = horizontalMinVector
        }
        if (dx > -horizontalMinVector && dx < 0)
        {
            dx = -horizontalMinVector
        }
        
        if (dy < verticalMinVector && dy > 0)
        {
            dy = verticalMinVector
        }
        if (dy > -verticalMinVector && dy < 0)
        {
            dy = -verticalMinVector
        }
        
        
        swimVector = CGVector(dx: dx, dy: dy) //keep track of the fish's vector so we can change it if it bangs into the side of the water
        
        let movement = SKAction.moveBy(swimVector, duration: duration)
        
//        self.physicsBody?.applyImpulse(swimVector)
        self.runAction(movement, completion: { () -> Void in
            let wait = SKAction.waitForDuration(NSTimeInterval(self.random(self.minPauseDuration, max: self.maxPauseDuration)))
            
            self.runAction(wait, completion: { () -> Void in
                self.moveFish()
            })
            
        })
        
    }
    
    func bounceFish()
    {
        
        print("bounce")
        
        //figure out the edge the fish has gone off of
//        if (self.position.x < -self.size.width/2.0)
//        {
//            
//            
//        }
//        else if
//        {
//        
//        
//        
//        }
//        else if
//        {
//        
//        
//        }
//        else
//        {
//            
//            
//        }
//        
//        || thisFish.position.x > self.view!.frame.width + thisFish.size.width/2.0
//        || thisFish.position.y < -thisFish.size.height/2.0 || thisFish.position.y > self.size.height + thisFish.size.height/2.0)
        
        
        //reflect the vector accordingly
        
        
    }
    
    func killFish() -> Int
    {
        
        self.removeFromParent()
        
        return self.pointValue
        
    }
    
    
    func pickRandomFish(level: Int) -> Fish
    {
        
        var newFish: Fish!
        
        let r = randomInt(1, upper: 100)
        
        if (level >= 1 && level <= 3)
        {
            if (r >= 1 && r <= 75)
            {
                newFish = RedFish()
            }
            else if (r >= 76 && r <= 90)
            {
                newFish = BlueFish()
            }
            else
            {
                newFish = GoldFish()
            }
        }
        else if (level >= 4 && level <= 6)
        {
            if (r >= 1 && r <= 45)
            {
                newFish = RedFish()
            }
            else if (r >= 46 && r <= 85)
            {
                newFish = BlueFish()
            }
            else
            {
                newFish = GoldFish()
            }
        }
        else if (level >= 7 && level <= 9)
        {
            if (r >= 1 && r <= 25)
            {
                newFish = RedFish()
            }
            else if (r >= 26 && r <= 50)
            {
                newFish = BlueFish()
            }
            else
            {
                newFish = GoldFish()
            }
        }
        else
        {
            if (r >= 1 && r <= 15)
            {
                newFish = RedFish()
            }
            else if (r >= 16 && r <= 40)
            {
                newFish = BlueFish()
            }
            else
            {
                newFish = GoldFish()
            }
            
        }
        
        return newFish
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomInt (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
