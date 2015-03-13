//
//  GameScene.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var harpoon: SKSpriteNode!
    var harpoonTip: SKSpriteNode!
    var harpoonTail: SKSpriteNode!
    var water: SKSpriteNode!

    enum ColliderType:UInt32
    {
        case Harpoon = 1
        case Water = 2
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        harpoon = self.childNodeWithName("harpoon") as SKSpriteNode
        harpoonTip = self.childNodeWithName("harpoonTip") as SKSpriteNode
        harpoonTail = self.childNodeWithName("harpoonTail") as SKSpriteNode
        water = self.childNodeWithName("water") as SKSpriteNode
        setupPhysics()


    }
    
    func setupPhysics()
    {
        

        
        self.physicsWorld.contactDelegate = self
        
        harpoonTail.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTail.size)
        harpoonTail.physicsBody!.pinned = true
        harpoonTail.physicsBody!.affectedByGravity = false
        harpoonTail.physicsBody!.allowsRotation = true
        harpoonTail.physicsBody!.mass = 1000.0
        
        harpoon.physicsBody = SKPhysicsBody(rectangleOfSize: harpoon.size)
        harpoon.physicsBody!.pinned = false
        harpoon.physicsBody!.affectedByGravity = true
        harpoon.physicsBody!.allowsRotation = true
        
        let harpoonRotationJoint = SKPhysicsJointPin.jointWithBodyA(harpoonTail.physicsBody, bodyB: harpoon.physicsBody, anchor: harpoonTail.position)
        self.physicsWorld.addJoint(harpoonRotationJoint)
        
        harpoonTip.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTip.size)
        harpoonTip.physicsBody!.pinned = false
        harpoonTip.physicsBody!.affectedByGravity = true
        harpoonTip.physicsBody!.allowsRotation = true
        
        let harpoonTipJoint = SKPhysicsJointFixed.jointWithBodyA(harpoon.physicsBody, bodyB: harpoonTip.physicsBody, anchor: harpoonTip.position)
        self.physicsWorld.addJoint(harpoonTipJoint)
        
        harpoon.physicsBody!.categoryBitMask = ColliderType.Harpoon.rawValue
        harpoon.physicsBody!.contactTestBitMask = ColliderType.Water.rawValue
        harpoon.physicsBody!.collisionBitMask = ColliderType.Water.rawValue
        

        
        water.physicsBody = SKPhysicsBody(edgeLoopFromRect: water.frame) //FIXME: contact not firing
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
            
            let controlPoint = touch.locationInView(self.view)
            println("user touched here: \(controlPoint)")
            throwHarpoon(controlPoint)

        }
    }
    
    func throwHarpoon(touch: CGPoint)
    {
        
        harpoonTip.physicsBody!.applyForce(CGVector(dx: 300.0, dy: 110.0))

        
        //harpoon.physicsBody!.pinned = false
        
        //figure out the force vector
        
        
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
