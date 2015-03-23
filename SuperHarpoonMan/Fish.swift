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
    var startingDepthMin: CGFloat!
    
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

      
        
    }
    
    
    func setupFish()
    {
        
       
        //assign the fish a random starting position in the water
        
//        self.position.x = 400.0
//        self.position.y = 300.0
        
//        self.position.x = random(min: self.size.width, max: parent!.frame.size.width - self.size.width)
//        self.position.y = random(min: self.size.height, max: parent!.frame.size.height - self.size.height)
        
//        self.fishIndex = fishIndex //keeping track of this fish in the array
        
        self.position.x = random(-20, max: 20)
        self.position.y = random(startingDepthMin, max: startingDepthMax)
        
        //define the fish's movement range
        horizontalRange = SKRange(lowerLimit: -20, upperLimit: 20)
        verticalRange = SKRange(lowerLimit: -20, upperLimit: 20)
        
        let movementBox = SKConstraint.positionX(horizontalRange, y: verticalRange)
        self.constraints = [movementBox]
        
        //set up fish physics
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.dynamic = false
//        self.physicsBody!.pinned = false
//        self.physicsBody!.affectedByGravity = false
//        self.physicsBody!.allowsRotation = false
        
        //set up fish collision detection
        self.physicsBody!.categoryBitMask = PhysicsCategory.Fish
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
        self.physicsBody!.contactTestBitMask = PhysicsCategory.HarpoonTip | PhysicsCategory.Water
        
        
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
        
        self.runAction(movement, completion: { () -> Void in
            var wait = SKAction.waitForDuration(NSTimeInterval(self.random(self.minPauseDuration, max: self.maxPauseDuration)))
            
            self.runAction(wait, completion: { () -> Void in
                self.moveFish()
            })
            
        })
        
    }
    
    func bounceFish()
    {
        
        
        
        
        
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
