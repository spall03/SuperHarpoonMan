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
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
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
        
//        self.position.x = 400.0
//        self.position.y = 300.0
        
//        self.position.x = random(self.size.width, max: parent!.frame.size.width - self.size.width)
//        self.position.y = random(self.size.height, max: parent!.frame.size.height - self.size.height)
        
//        self.fishIndex = fishIndex //keeping track of this fish in the array
        
        self.position.x = random(midScreen.x - 50, max: midScreen.x + 50)
        self.position.y = random(midScreen.y, max: startingDepthMax)
        
//        self.position.x = 0
//        self.position.y = 0
    
        
        //define the fish's movement range
        horizontalRange = SKRange(lowerLimit: -20, upperLimit: 20)
        verticalRange = SKRange(lowerLimit: -20, upperLimit: 20)
        
        let movementBox = SKConstraint.positionX(horizontalRange, y: verticalRange)
        //self.constraints = [movementBox]
        
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
        var duration = NSTimeInterval(random(minVectorDuration, max: maxVectorDuration))
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
        
        var movement = SKAction.moveBy(swimVector, duration: duration)
        
//        self.physicsBody?.applyImpulse(swimVector)
        self.runAction(movement, completion: { () -> Void in
            var wait = SKAction.waitForDuration(NSTimeInterval(self.random(self.minPauseDuration, max: self.maxPauseDuration)))
            
            self.runAction(wait, completion: { () -> Void in
                self.moveFish()
            })
            
        })
        
    }
    
    func bounceFish()
    {
        
        println("bounce")
        
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
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomInt (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(upper - lower + 1))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
