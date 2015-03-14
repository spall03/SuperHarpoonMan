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
    
    enum ColliderType:UInt32
    {
        case Harpoon = 1
        case Water = 2
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //build crosshairs
        crosshairs = self.childNodeWithName("crosshairs") as SKSpriteNode
        
        //build the harpoon
        harpoonTail = self.childNodeWithName("harpoonTail") as SKSpriteNode
        harpoonBody =  harpoonTail.childNodeWithName("harpoonBody") as SKSpriteNode
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
        
        harpoonTail.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTail.size)
        harpoonTail.physicsBody!.pinned = true
        harpoonTail.physicsBody!.affectedByGravity = true
        harpoonTail.physicsBody!.allowsRotation = true
        harpoonTail.physicsBody!.friction = 0.0
        harpoonTail.physicsBody!.mass = 10.0
        
        
        
        harpoonBody.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonBody.size)
        harpoonBody.physicsBody!.pinned = true
        harpoonBody.physicsBody!.affectedByGravity = true
        harpoonBody.physicsBody!.allowsRotation = false
        harpoonBody.physicsBody!.friction = 0.0
        harpoonBody.physicsBody!.mass = 100.0

        
        harpoonTip.physicsBody = SKPhysicsBody(rectangleOfSize: harpoonTip.size)
        harpoonTip.physicsBody!.pinned = true
        harpoonTip.physicsBody!.affectedByGravity = true
        harpoonTip.physicsBody!.allowsRotation = false
        harpoonTip.physicsBody!.friction = 0.0
        harpoonTip.physicsBody!.mass = 0.0

        
        harpoonTip.physicsBody!.categoryBitMask = ColliderType.Harpoon.rawValue
        harpoonTip.physicsBody!.contactTestBitMask = ColliderType.Water.rawValue
        harpoonTip.physicsBody!.collisionBitMask = ColliderType.Water.rawValue
        

        
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
            
//            let controlPoint = touch.locationInView(self.view)
//            println("user touched here: \(controlPoint)")
            //throwHarpoon(controlPoint)

        }
    }
    
    func throwHarpoon(touch: CGPoint)
    {

        // TODO: So I can get the harpoon swaying to the beat if I do this:
        //harpoonTip.physicsBody!.applyForce(CGVector(dx: 300.0, dy: 110.0))
        // TODO: So if you only want to move the harpoonTip you don't need to set the friction on the
        // harpoon to 0.0, as well, just the friction on the harpoonTip

        // TODO: or if I do this:
        // harpoon.physicsBody!.applyForce(CGVector(dx: 300.0, dy: 110.0))
        
        //harpoon.physicsBody!.pinned = false
        
        //figure out the force vector
        
    }
    
    func getAngle (harpoonTail: CGPoint, crosshairs: CGPoint) -> CGFloat
    {
        let dx = harpoonTail.x - crosshairs.x
        let dy = harpoonTail.y - crosshairs.y
        
        return atan2(dy, dx)
    }
    
    func adjustHarpoonAngle (angle: CGFloat)
    {
        
        //let degrees = (angle * (180 / CGFloat(M_PI))) - 90
        
        let newAngle = angle - (CGFloat(M_PI) / 2)
        
        println(newAngle)
        
        
        
        let harpoonSpin = SKAction.rotateByAngle(newAngle, duration: 0.01)
        harpoonTail.runAction(harpoonSpin)
        
    }
    


    func handlePan(recognizer: UIPanGestureRecognizer)
    {
        
        var angle: CGFloat
        
        if ( recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Changed)
        {

            
            crosshairs.position = self.convertPointFromView(recognizer.locationInView(self.view))
            
            angle = getAngle(harpoonTail.position, crosshairs: crosshairs.position)
            
            //println(angle)
            
            adjustHarpoonAngle(angle)
            
            
            

        }
//        else if (recognizer.state == UIGestureRecognizerState.Changed)
//        {
//            crosshairs.position = self.convertPointFromView(recognizer.locationInView(self.view))
//            
//             println(getAngle(harpoonTail.position, crosshairs: crosshairs.position))
//            
//        }
        
        else if (recognizer.state == UIGestureRecognizerState.Ended)
        {
            var location = recognizer.locationInView( self.view )
            location = self.convertPointFromView( location )
            
            var dx = location.x - harpoonTip.position.x;
            var dy = location.y - harpoonTip.position.y;
            
            // Determine the direction to spin the node
            //let direction = ( harpoonStart!.x * dy - harpoonStart!.y * dx );
            
            dx = recognizer.velocityInView( self.view ).x
            dy = recognizer.velocityInView( self.view ).y
            
            //let speed = sqrt( dx*dx + dy*dy ) * 0.25
            
             //Apply impulse
//            let vector = CGVector(dx: dx * 0.1, dy: dy * 0.1)
//            
//            harpoonBody.physicsBody!.pinned = false
//            harpoonBody.physicsBody!.applyImpulse(vector)
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
