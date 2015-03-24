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
    static let Fish      : UInt32 = 0b101     // 5
    static let WaterEdge : UInt32 = 0b110     // 6
}




class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {


    var crosshairs: SKSpriteNode!
    
    var harpoon: Harpoon!
    var harpoonsLeft: Int = 0
    var score: Int = 0

    var water: SKSpriteNode!
    
    var leftsky: SKSpriteNode!
    var rightsky: SKSpriteNode!
    
    var waterSides: SKSpriteNode!
    
    var harpoonLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    //var fishArray: [Fish!] = []
    var numberOfFish: Int = 0
    var fishCounter: Int = 0
    
    var level: Int = 1


    override func didMoveToView(view: SKView) {
        
        
        //build crosshairs
        crosshairs = self.childNodeWithName("crosshairs") as SKSpriteNode
        
        //build the harpoon and add initial harpoon count
        createNewHarpoon()
        harpoonsLeft = 99
        
        numberOfFish = 5

        
        //add water
        water = self.childNodeWithName("water") as SKSpriteNode
        
        waterSides = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: water.size)
        waterSides.position = water.position
        waterSides.alpha = 0 //make it invisible
        self.addChild(waterSides)
        
        //add sky borders
        leftsky = self.childNodeWithName("leftsky") as SKSpriteNode
        rightsky = self.childNodeWithName("rightsky") as SKSpriteNode
        
        //setup labels
        setupLabels()
        
        //add fish
        addFish(numberOfFish)
        
        //setup scene physics
        setupPhysics()

        //add gesture recognizer
        let panGesture = UIPanGestureRecognizer( target: self, action:Selector("handlePan:") )
        panGesture.delegate = self
        view.addGestureRecognizer( panGesture )

    }
    
    func pickRandomFish() -> Fish
    {
        
        var newFish: Fish!
        
        var r = randomInt(1, upper: 100)
        
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
    
    func addFish(numberOfFish:Int)
    {
        
        
        for var i = 0; i < numberOfFish; i++
        {
            let newFish = pickRandomFish()
            self.addChild(newFish)
            newFish.setupFish()
            newFish.moveFish()
            
            fishCounter++
        }
        
        
    }
    
    func setupLabels()
    {
        harpoonLabel = SKLabelNode(text: "Harpoons: \(harpoonsLeft)")
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        levelLabel = SKLabelNode(text: "Level: \(level)")
        
        harpoonLabel.position = CGPointMake(300.0, 650.0)
        harpoonLabel.fontName = "Chalkduster"
        harpoonLabel.fontSize = 18
        
        scoreLabel.position = CGPointMake(300.0, 635.0)
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 14
        
        levelLabel.position = CGPointMake(300.0, 615.0)
        levelLabel.fontName = "Chalkduster"
        levelLabel.fontSize = 14
        
        self.addChild(harpoonLabel)
        self.addChild(scoreLabel)
        self.addChild(levelLabel)
        
    }
    
    func updateLabels()
    {
        harpoonLabel.text = "Harpoons: \(harpoonsLeft)"
        scoreLabel.text = "Score: \(score)"
        levelLabel.text = "Level: \(level)"
    }
    
    func createNewHarpoon()
    {
        harpoon = Harpoon(texture: nil, color: UIColor.whiteColor(), size: CGSizeMake(150.0, 5.0))
        self.addChild(harpoon)
        harpoon.setupHarpoon()
        self.view?.userInteractionEnabled = true
    }
    
    func killHarpoon()
    {
        harpoon.physicsBody = nil
        harpoon.removeFromParent()
        harpoonsLeft--
        updateLabels()
       
    }
    
    func setupPhysics()
    {
        
        self.physicsWorld.contactDelegate = self
        
        water.physicsBody = SKPhysicsBody(rectangleOfSize: water.size)
        water.physicsBody!.dynamic = false
        water.physicsBody!.categoryBitMask = PhysicsCategory.Water
        water.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        water.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        waterSides.physicsBody = SKPhysicsBody(rectangleOfSize: waterSides.size)
//        println(self.view!.frame)
        waterSides.physicsBody!.dynamic = false
        waterSides.physicsBody!.categoryBitMask = PhysicsCategory.WaterEdge
        waterSides.physicsBody!.contactTestBitMask = PhysicsCategory.Fish
        waterSides.physicsBody!.collisionBitMask = PhysicsCategory.None
        
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

        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Harpoon) && (contact.bodyB.categoryBitMask == PhysicsCategory.Water)
        {
            println("harpoon is in the water!")
            contact.bodyA.linearDamping = 9.0
            
            
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.HarpoonTip) && (contact.bodyB.categoryBitMask == PhysicsCategory.Fish)
        {
            println("you hit a fish!")
            
            
        }
        
//        if (contact.bodyA.categoryBitMask == PhysicsCategory.Fish) && (contact.bodyB.categoryBitMask == PhysicsCategory.WaterEdge)
//        {
//            println("Fish out of water!")
//            
//        }
        
  
    }
    
    func fishHit (contact: SKPhysicsContact)
    {
        var deadFish = contact.bodyB.node as Fish
        score += deadFish.killFish()
        fishCounter--
        
        updateLabels()
        levelCheck()
        
    }
    
    
    func levelCheck()
    {
        if fishCounter == 0
        {
            println("all the fish are gone!")
            
            level++
            updateLabels()
            addFish(numberOfFish)
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.HarpoonTip) && (contact.bodyB.categoryBitMask == PhysicsCategory.Fish)
        {
            println("harpoon has speared a fish!")
            fishHit(contact)
            
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Harpoon) && (contact.bodyB.categoryBitMask == PhysicsCategory.Water || contact.bodyB.categoryBitMask == PhysicsCategory.Sky)
        {
            println("harpoon has left the screen!")
            
            killHarpoon()
            createNewHarpoon()

        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Fish) && (contact.bodyB.categoryBitMask == PhysicsCategory.WaterEdge)
        {
            let fish = contact.bodyA.node as Fish
            fish.bounceFish()
            
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
            
            self.view?.userInteractionEnabled = false //disallow controls
            
            harpoon.physicsBody!.pinned = false
            harpoon.physicsBody!.applyImpulse(impulse)
           
        
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
//        self.enumerateChildNodesWithName("fish", usingBlock: {
//            (fish: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
//            
//            let thisFish = fish as Fish
//            
//            if (thisFish.position.x < -thisFish.size.width/2.0 || thisFish.position.x > self.view!.frame.width + thisFish.size.width/2.0
//            || thisFish.position.y < -thisFish.size.height/2.0 || thisFish.position.y > self.size.height + thisFish.size.height/2.0)
//            
//            {
//                    thisFish.bounceFish()
//            }
//            
//        })
    
        
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
