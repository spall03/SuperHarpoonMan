//
//  GameScene.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {

    var crosshairs: SKSpriteNode!

    var harpoonTail: SKSpriteNode!
    var harpoonBody: SKSpriteNode!
    var harpoonTip: SKSpriteNode!

    var water: SKSpriteNode!

    var harpoonStart: CGPoint?
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let HarpoonTip: UInt32 = 0b1       // 1
        static let Harpoon   : UInt32 = 0b10      // 2
        static let Water     : UInt32 = 0b11      // 3
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //build crosshairs
        crosshairs = self.childNodeWithName("crosshairs") as SKSpriteNode
        
        //build the harpoon
        harpoonBody =  self.childNodeWithName("harpoonBody") as SKSpriteNode
        harpoonTip = harpoonBody.childNodeWithName("harpoonTip") as SKSpriteNode
        

        //add water
        water = self.childNodeWithName("water") as SKSpriteNode
        
        setupPhysics()

        //add gesture recognizer
        let panGesture = UIPanGestureRecognizer( target: self, action:Selector("handlePan:") )
        panGesture.delegate = self
        view.addGestureRecognizer( panGesture )

    }
    
    func setupPhysics()
    {
        

        
        self.physicsWorld.contactDelegate = self
        
        
        
        
        
        
        
        harpoonBody.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonBody.size)
        harpoonBody.physicsBody!.pinned = true
        harpoonBody.physicsBody!.affectedByGravity = true
        harpoonBody.physicsBody!.allowsRotation = true
        //harpoonBody.physicsBody!.friction = 0.0
        harpoonBody.physicsBody!.mass = 10.0
        harpoonBody.physicsBody!.categoryBitMask = PhysicsCategory.Harpoon
        harpoonBody.physicsBody!.collisionBitMask = PhysicsCategory.None
        harpoonBody.physicsBody!.contactTestBitMask = PhysicsCategory.Water


        
        harpoonTip.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTip.size)
        harpoonTip.physicsBody!.pinned = true
        harpoonTip.physicsBody!.affectedByGravity = false
        harpoonTip.physicsBody!.allowsRotation = false
        //harpoonTip.physicsBody!.friction = 0.0
        harpoonTip.physicsBody!.mass = 20.0
        harpoonTip.physicsBody!.categoryBitMask = PhysicsCategory.HarpoonTip
        //harpoonTip.physicsBody!.contactTestBitMask = PhysicsCategory.Water
        harpoonTip.physicsBody!.collisionBitMask = PhysicsCategory.None
        harpoonTip.physicsBody!.usesPreciseCollisionDetection = true
        

        
        water.physicsBody = SKPhysicsBody(rectangleOfSize: water.size) //FIXME: contact not firing
        water.physicsBody!.dynamic = false
        water.physicsBody!.categoryBitMask = PhysicsCategory.Water
        water.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        water.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Harpoon != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Water != 0))
        {
                println("harpoon is in the water!")
                firstBody.linearDamping = 9.0
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            

        }
    }
    
    
    func getAngle (crosshairs: CGPoint) -> CGFloat
    {
        let dx = harpoonBody.position.x - crosshairs.x
        let dy = harpoonBody.position.y - crosshairs.y
        
        return atan2(dy, dx)
    }
    
    func degreesToRadians (angle: CGFloat) -> CGFloat
    {
        
        return angle * (angle * 0.01745329252)
        
    }
    
    func adjustHarpoonAngle (angle: CGFloat)
    {
        
        
        let newAngle = angle - degreesToRadians(90.0)
        
        harpoonBody.zRotation = newAngle
        
        
    }
    
    func getHarpoonImpulse() -> CGVector
    {
        
        let force = CGFloat(30000.0)
        
        let dx = (force * (cos(harpoonBody.zRotation)))
        let dy = (force * (sin(harpoonBody.zRotation)))
        
        println("\(dx), \(dy)")
        
        return CGVectorMake(dx, dy)
        
        
        
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer)
    {
        
        var angle: CGFloat
        
        if ( recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Changed)
        {

            
            crosshairs.position = self.convertPointFromView(recognizer.locationInView(self.view))
            
            angle = getAngle(crosshairs.position)
            
            adjustHarpoonAngle(angle)
            

        }
        else if (recognizer.state == UIGestureRecognizerState.Ended)
        {
            
            let impulse = getHarpoonImpulse()
            
            harpoonBody.physicsBody!.pinned = false
            harpoonBody.physicsBody!.applyImpulse(impulse)
           
        
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
