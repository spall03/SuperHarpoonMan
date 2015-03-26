//
//  Harpoon.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/17/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import Foundation
import SpriteKit


class Harpoon: SKSpriteNode
{
    
    let harpoonPosX: CGFloat = 125.0
    let harpoonPosY: CGFloat = 600.0
    
    let harpoonTipPosX: CGFloat = 75.0
    let harpoonTipPosY: CGFloat = 0.0
    
    var harpoonTip: SKSpriteNode!
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    
        //initialize harpoon tip
        harpoonTip = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: CGSizeMake(10.0, 1.0))
        self.addChild(harpoonTip)
        harpoonTip.position = CGPointMake(harpoonTipPosX, harpoonTipPosY)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHarpoon()
    {
        //move harpoon to starting position
        self.position.x = harpoonPosX
        self.position.y = harpoonPosY
        
        //set up harpoon body physics
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.pinned = true
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.allowsRotation = true
        self.physicsBody!.mass = 10.0
        
        //set up harpoon body collision
        self.physicsBody!.categoryBitMask = PhysicsCategory.Harpoon
        self.physicsBody!.collisionBitMask = PhysicsCategory.WaterEdge
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Water
        
        //set up harpoon tip physics
        harpoonTip.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTip.size)
        harpoonTip.physicsBody!.pinned = true
        harpoonTip.physicsBody!.affectedByGravity = false
        harpoonTip.physicsBody!.allowsRotation = false
        harpoonTip.physicsBody!.mass = 20.0
        
        //set up harpoon tip collision
        harpoonTip.physicsBody!.categoryBitMask = PhysicsCategory.HarpoonTip
        harpoonTip.physicsBody!.contactTestBitMask = PhysicsCategory.Fish
        harpoonTip.physicsBody!.collisionBitMask = PhysicsCategory.None
        harpoonTip.physicsBody!.usesPreciseCollisionDetection = true
    }

    
    
    
    
}
