//
//  GameScene.swift
//  SuperHarpoonMan
//
//  Created by Stephen Palley on 3/12/15.
//  Copyright (c) 2015 clownbox. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let HarpoonTip: UInt32 = 0b1       // 1
    static let Harpoon   : UInt32 = 0b10      // 2
    static let Water     : UInt32 = 0b11      // 3
    static let Sky       : UInt32 = 0b100     // 4
}


class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {


    var crosshairs: SKSpriteNode!
    
    var harpoon: Harpoon!
    var harpoonsLeft: Int = 0
    var score: Int = 0

    var water: SKSpriteNode!
    
    var leftsky: SKSpriteNode!
    var rightsky: SKSpriteNode!
    
    var harpoonLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!


    override func didMoveToView(view: SKView) {
        
        
        //build crosshairs
        crosshairs = self.childNodeWithName("crosshairs") as SKSpriteNode
        
        //build the harpoon and add initial harpoon count
        createNewHarpoon()
        harpoonsLeft = 99
        
        //add water
        water = self.childNodeWithName("water") as SKSpriteNode
        
        //add sky borders
        leftsky = self.childNodeWithName("leftsky") as SKSpriteNode
        rightsky = self.childNodeWithName("rightsky") as SKSpriteNode
        
        //setup scene physics
        setupPhysics()
        
        //setup labels
        setupLabels()

        //add gesture recognizer
        let panGesture = UIPanGestureRecognizer( target: self, action:Selector("handlePan:") )
        panGesture.delegate = self
        view.addGestureRecognizer( panGesture )

    }
    
    func setupLabels()
    {
        harpoonLabel = SKLabelNode(text: "Harpoons: \(harpoonsLeft)")
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        
        harpoonLabel.position = CGPointMake(510.0, 725.0)
        harpoonLabel.fontName = "Chalkduster"
        harpoonLabel.fontSize = 18
        
        self.addChild(harpoonLabel)
        
    }
    
    func createNewHarpoon()
    {
        harpoon = Harpoon(texture: nil, color: UIColor.whiteColor(), size: CGSizeMake(150.0, 5.0))
        self.addChild(harpoon)
        harpoon.setupHarpoon()
    }
    
    func killHarpoon()
    {
        harpoon.physicsBody = nil
        harpoon.removeFromParent()
        harpoonsLeft -= 1
        harpoonLabel.text = "Harpoons: \(harpoonsLeft)"
    }
    
    func setupPhysics()
    {
        
        self.physicsWorld.contactDelegate = self
        
        water.physicsBody = SKPhysicsBody(rectangleOfSize: water.size)
        water.physicsBody!.dynamic = false
        water.physicsBody!.categoryBitMask = PhysicsCategory.Water
        water.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        water.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        leftsky.physicsBody = SKPhysicsBody(rectangleOfSize: leftsky.size)
        leftsky.physicsBody!.dynamic = false
        leftsky.physicsBody!.categoryBitMask = PhysicsCategory.Sky
        leftsky.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        leftsky.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        rightsky.physicsBody = SKPhysicsBody(rectangleOfSize: rightsky.size)
        rightsky.physicsBody!.dynamic = false
        rightsky.physicsBody!.categoryBitMask = PhysicsCategory.Sky
        rightsky.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        rightsky.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        
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
    
    func didEndContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        //harpoon exits screen through the water
        if ((firstBody.categoryBitMask & PhysicsCategory.Harpoon != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Water != 0))
        {
            println("harpoon has left the screen!")
            
            killHarpoon()
            createNewHarpoon()
            
        }
        
        //harpoon exits screen through the air
        if ((firstBody.categoryBitMask & PhysicsCategory.Harpoon != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Sky != 0))
        {
            println("harpoon has left the screen!")
            
            killHarpoon()
            createNewHarpoon()
            
        }

        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            

        }
    }
    
    
    func getAngle (crosshairs: CGPoint) -> CGFloat
    {
        let dx = harpoon.position.x - crosshairs.x
        let dy = harpoon.position.y - crosshairs.y
        
        return atan2(dy, dx)
    }
    
    func degreesToRadians (angle: CGFloat) -> CGFloat
    {
        
        return angle * (angle * 0.01745329252)
        
    }
    
    func adjustHarpoonAngle (angle: CGFloat)
    {
        
        
        let newAngle = angle - degreesToRadians(90.0)
        
        harpoon.zRotation = newAngle
        
        
    }
    
    func getHarpoonImpulse() -> CGVector
    {
        
        let force = CGFloat(30000.0)
        
        let dx = (force * (cos(harpoon.zRotation)))
        let dy = (force * (sin(harpoon.zRotation)))
        
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
            
            harpoon.physicsBody!.pinned = false
            harpoon.physicsBody!.applyImpulse(impulse)
           
        
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
