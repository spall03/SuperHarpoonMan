//
//  GameScene.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    

    enum ColliderType:UInt32
    {
        case Harpoon = 1
        case Water = 2
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
            setupPhysics()


    }
    
    func setupPhysics()
    {
        

        
        self.physicsWorld.contactDelegate = self
        //self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        
        let harpoon = self.childNodeWithName("harpoon") as SKSpriteNode
        harpoon.physicsBody = SKPhysicsBody(rectangleOfSize: harpoon.size)
        harpoon.physicsBody!.pinned = true
        harpoon.physicsBody!.affectedByGravity = true
        harpoon.physicsBody!.allowsRotation = true
        harpoon.physicsBody!.categoryBitMask = ColliderType.Harpoon.rawValue
        harpoon.physicsBody!.contactTestBitMask = ColliderType.Water.rawValue
        harpoon.physicsBody!.collisionBitMask = ColliderType.Water.rawValue
        
        let water = self.childNodeWithName("water") as SKSpriteNode
        water.physicsBody = SKPhysicsBody(edgeLoopFromRect: water.frame)
        water.physicsBody!.categoryBitMask = ColliderType.Water.rawValue
        water.physicsBody!.contactTestBitMask = ColliderType.Harpoon.rawValue
        water.physicsBody!.collisionBitMask = ColliderType.Harpoon.rawValue
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Harpoon.rawValue && contact.bodyB.categoryBitMask == ColliderType.Water.rawValue
        {
            println("The harpoon is in the water at \(contact.contactPoint)!")
            contact.bodyA.linearDamping = 0.5 //water viscosity
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
