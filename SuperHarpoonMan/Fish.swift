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
        
        self.position.x = random(min: -20, max: 20)
        self.position.y = random(min: -20, max: 20)
        
        //define the fish's movement range
//        horizontalRange = SKRange(lowerLimit: water.frame.minX, upperLimit: water.frame.maxX)
//        verticalRange = SKRange(lowerLimit: water.frame.minY, upperLimit: water.frame.maxY)
//        
//        let movementBox = SKConstraint.positionX(horizontalRange, y: verticalRange)
//        self.constraints = [movementBox]
        
        //set up fish physics
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.dynamic = false
//        self.physicsBody!.pinned = false
//        self.physicsBody!.affectedByGravity = false
//        self.physicsBody!.allowsRotation = false
        
        //set up fish collision detection
        self.physicsBody!.categoryBitMask = PhysicsCategory.Fish
        self.physicsBody!.collisionBitMask = PhysicsCategory.None
        self.physicsBody!.contactTestBitMask = PhysicsCategory.HarpoonTip
        
        
    }
    
    func moveFish()
    {
        var duration = NSTimeInterval(random(min: 2.0, max: 5.0))
        var dx = random(min: -20.0, max: 20.0)
        var dy = random(min: -20.0, max: 20.0)
        
        swimVector = CGVector(dx: dx, dy: dy) //keep track of the fish's vector so we can change it if it bangs into the side of the water
        
        var movement = SKAction.moveBy(swimVector, duration: duration)
        
        self.runAction(movement, completion: { () -> Void in
            var wait = SKAction.waitForDuration(NSTimeInterval(self.random(min: 1.0, max: 5.0)))
            
            self.runAction(wait, completion: { () -> Void in
                self.moveFish()
            })
            
        })
        
    }
    
    func bounceFish()
    {
        
        
        
        
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
