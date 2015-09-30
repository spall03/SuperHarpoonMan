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
    
    var throwScore: Int = 0 //keeps track of what's been scored on a single throw
    var extraHarpoonThreshold: Int = 50 //score this number of points on a throw for an extra harpoon

    var water: SKSpriteNode!
    
    var leftsky: SKSpriteNode!
    var rightsky: SKSpriteNode!
    
    var waterSides: SKSpriteNode!
    
    var harpoonLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    var numberOfFish: Int = 0
    var fishCounter: Int = 0
    
    var level: Int = 1


    //MARK: Setup
    
    override func didMoveToView(view: SKView) {
        
        
        //build crosshairs
        crosshairs = self.childNodeWithName("crosshairs") as! SKSpriteNode
        
        //build the harpoon and add initial harpoon count
        createNewHarpoon()
        harpoonsLeft = 10
        
        numberOfFish = 5

        
        //add water
        water = self.childNodeWithName("water") as! SKSpriteNode
        
        waterSides = SKSpriteNode(texture: nil, color: UIColor.whiteColor(), size: water.size)
        waterSides.position = water.position
        waterSides.alpha = 0 //make it invisible
        self.addChild(waterSides)
        
        //add sky borders
        leftsky = self.childNodeWithName("leftsky") as! SKSpriteNode
        rightsky = self.childNodeWithName("rightsky") as! SKSpriteNode
        
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
    
    func setupPhysics()
    {
        
        self.physicsWorld.contactDelegate = self
        
        water.physicsBody = SKPhysicsBody(rectangleOfSize: water.size)
        water.physicsBody!.dynamic = false
        water.physicsBody!.categoryBitMask = PhysicsCategory.Water
        water.physicsBody!.contactTestBitMask = PhysicsCategory.Harpoon
        water.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        waterSides.physicsBody = SKPhysicsBody(rectangleOfSize: waterSides.size)
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
    
//MARK: Fish
    
    func addFish(numberOfFish:Int)
    {
        
        var counter = 0
        
        //fill up with a certain number of points' worth of fish
        while counter < (4 * extraHarpoonThreshold)
        {
            let newFish = pickRandomFish()
            self.addChild(newFish)
            newFish.setupFish()
            newFish.moveFish()
            
            counter += newFish.pointValue
            fishCounter++
        }
        
        
    }
    
    func pickRandomFish() -> Fish
    {
        
        var newFish: Fish!
        
        let r = randomInt(1, upper: 100)
        
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
    
//MARK: Harpoon
    
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
        
        if harpoonsLeft == 0
        {
            gameOver()
            
        }
        
    }
    
    func betweenHarpoonThrows()
    {
        
        let postThrowLabel = SKLabelNode(fontNamed: "chalkduster")
        postThrowLabel.fontSize = 24
        postThrowLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        
        let postThrowLabelString = "Last Throw: +\(throwScore)"
        
        if throwScore >= extraHarpoonThreshold
        {
            //postThrowLabelString += "Extra Harpoon Awarded!"
            harpoonsLeft++
        }
        
        postThrowLabel.text = postThrowLabelString
        self.addChild(postThrowLabel)
        
        let floatAction = SKAction.moveBy(CGVectorMake(0, 20), duration: 2)
        postThrowLabel.runAction(floatAction, completion: { () -> Void in
            postThrowLabel.removeFromParent()
        })
        
        
        throwScore = 0 //reset score counter for next throw
        
        killHarpoon()
        createNewHarpoon()
        
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
        
        print("\(dx), \(dy)")
        
        return CGVectorMake(dx, dy)
        
    }
    
    
    //MARK: Physics Contact Handlers
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Harpoon) && (contact.bodyB.categoryBitMask == PhysicsCategory.Water)
        {
            print("harpoon is in the water!")
            contact.bodyA.linearDamping = 9.0
            
            
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.HarpoonTip) && (contact.bodyB.categoryBitMask == PhysicsCategory.Fish)
        {
            print("you hit a fish!")
            
            
        }
        
        //        if (contact.bodyA.categoryBitMask == PhysicsCategory.Fish) && (contact.bodyB.categoryBitMask == PhysicsCategory.WaterEdge)
        //        {
        //            println("Fish out of water!")
        //
        //        }
        
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.HarpoonTip) && (contact.bodyB.categoryBitMask == PhysicsCategory.Fish)
        {
            print("harpoon has speared a fish!")
            fishHit(contact)
            
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Harpoon) && (contact.bodyB.categoryBitMask == PhysicsCategory.Water || contact.bodyB.categoryBitMask == PhysicsCategory.Sky)
        {
            print("harpoon has left the screen!")
            
            betweenHarpoonThrows()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Fish) && (contact.bodyB.categoryBitMask == PhysicsCategory.WaterEdge)
        {
            let fish = contact.bodyA.node as! Fish
            fish.bounceFish()
            
        }
        
        
        
    }
    
    func fishHit (contact: SKPhysicsContact)
    {
        let deadFish = contact.bodyB.node as! Fish
        
        let scoreLabel = SKLabelNode(text: "+\(deadFish.pointValue)")
        scoreLabel.fontName = "chalkduster"
        scoreLabel.fontSize = 12
        scoreLabel.position = deadFish.position
        self.addChild(scoreLabel)
        
        let floatAction = SKAction.moveBy(CGVectorMake(0, 20), duration: 2)
        scoreLabel.runAction(floatAction, completion: { () -> Void in
            scoreLabel.removeFromParent()
        })
        
        
        throwScore += deadFish.pointValue
        score += deadFish.killFish()
        
        fishCounter--
        
        updateLabels()
        levelCheck()
        
    }
    
    //MARK: Game Updaters
    
    func achievementCheck()
    {
        
        if score >= 100
        {
            GameKitHelper.sharedInstance.reportAchievement("shm_score_100_points", percentComplete: 100.0)
        }
        
        
        
        
    }
    
    func pauseGame()
    {
        
        print("game is paused!")
        
        
    }
    
    func updateLabels()
    {
        harpoonLabel.text = "Harpoons: \(harpoonsLeft)"
        scoreLabel.text = "Score: \(score)"
        levelLabel.text = "Level: \(level)"
    }
    
    
    
    func gameOver()
    {
        
        achievementCheck()
        
        GameKitHelper.sharedInstance.saveToLeaderboard(score)
        NSNotificationCenter.defaultCenter().postNotificationName(superHarpoonManGameIsOver, object: nil)
        
    }
    
    func levelCheck()
    {
        if fishCounter == 0
        {
            print("all the fish are gone!")
            
            level++
            updateLabels()
            addFish(numberOfFish)
            
        }
        
    }
    
    //MARK: Touch Handers
    
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
    
    //MARK: Helper Methods
    
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
    
    func randomInt (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    

    


    
}
