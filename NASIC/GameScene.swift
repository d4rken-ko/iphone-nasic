//
//  GameScene.swift
//  NASIC
//
//  Created by Matthias Urhahn on 06/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    enum BodyType : UInt32 {
        case Player = 1 // (1 << 0)
        case PlayerBullet = 2 // (1 << 1)
        case Android = 4 // (1 << 2)
        case AndroidBullet = 8 // (1 << 3)
        case Wall = 16 // (1 << 4)
    }

    var difficultyMultiplier = 1;

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        backgroundColor = SKColor(rgba: "#2D2D2D")
        let worldBody = SKPhysicsBody (edgeLoopFromRect: self.frame)
        worldBody.restitution = 0.3
        worldBody.categoryBitMask = BodyType.Wall.rawValue
        self.physicsBody = worldBody
        self.physicsWorld.contactDelegate = self


        let player = makePlayer()
        addChild(player)

        //  let testBlock = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: self.frame.width - 5, height: self.frame.height - 5))
        //  testBlock.position = CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //  addChild(testBlock)

        let androidBlock = makeAndroidBlock()
        addChild(androidBlock)

        dropDistance = CGFloat(2 +  1 * difficultyMultiplier/2)
        stepDistance = CGFloat(1 + 1 * difficultyMultiplier/2)
    }

    func makePlayer() -> SKSpriteNode {
        let player = SKSpriteNode(imageNamed: "apple_rotated1")
        player.name = "Player"
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame)+player.frame.height+10);
        player.runAction(SKAction.scaleBy(0.5, duration: 0))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.frame.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.mass = 0.7
        player.physicsBody?.linearDamping = 2.0
        player.physicsBody?.angularDamping = 1.0
        player.physicsBody?.categoryBitMask = BodyType.Player.rawValue
        player.physicsBody?.contactTestBitMask = 0
        player.physicsBody?.collisionBitMask = BodyType.Wall.rawValue
        return player
    }


    func makeAndroidBlock() -> SKNode {
        let _androidBlock = SKNode()
        _androidBlock.name = "Androids"
        for column in 1...6 {
            for row in 1...5 {
                let android = SKSpriteNode(imageNamed: "android_head1")
                android.name = "Android"
                android.runAction(SKAction.scaleBy(0.5, duration: 0))
                android.physicsBody = SKPhysicsBody(rectangleOfSize: android.frame.size)
                android.physicsBody?.dynamic = true
                android.physicsBody?.affectedByGravity = false
                android.physicsBody?.mass = 0.4
                android.physicsBody?.linearDamping = 1.0
                android.physicsBody?.angularDamping = 1.0
                android.physicsBody?.categoryBitMask = BodyType.Android.rawValue
                android.physicsBody?.contactTestBitMask = BodyType.Player.rawValue
                android.physicsBody?.collisionBitMask = BodyType.Wall.rawValue | BodyType.Player.rawValue

                android.position = CGPoint(x:CGFloat(35*column), y:CGFloat(35*row))
                _androidBlock.addChild(android)
            }
        }
        let blockSize = _androidBlock.calculateAccumulatedFrame()
        _androidBlock.position = CGPoint(x:(CGRectGetMidX(self.frame) - CGRectGetMidX(blockSize)), y:(CGRectGetMaxY(self.frame) - CGRectGetHeight(blockSize) - CGFloat(100)));


        //let testBlock = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: blockSize.width, height: blockSize.height))
        //_androidBlock.addChild(testBlock)
        //testBlock.position = CGPoint(x:(CGRectGetMinX(blockSize) + CGRectGetWidth(blockSize)/2), y: CGRectGetMinY(blockSize) + CGRectGetHeight(blockSize)/2)

        return _androidBlock
    }


    enum AndroidMove {
        case Left,Right
    }

    var nextMove = AndroidMove.Left
    var lastAndroidsMovement: CFTimeInterval  = 0
    var stepDistance: CGFloat = 1 // overridden with multiplier
    var dropDistance: CGFloat = 1 // overridden with multiplier
    let androidsSpeed: CFTimeInterval = 0.01
    var lastAndroidRetaliation: CFTimeInterval = 0

    func updateAndroidsPosition(currentTime: CFTimeInterval) {
        if  ((currentTime - lastAndroidsMovement) < androidsSpeed as CFTimeInterval) {
            return
        }
        let androids = self.childNodeWithName("Androids") as SKNode!
        let androidsFrame = androids.calculateAccumulatedFrame()
        if(nextMove == AndroidMove.Left) {
            if((CGRectGetMinX(androidsFrame) - stepDistance) < CGRectGetMinX(self.frame)) {
                androids.position = CGPoint(x: androids.position.x,y: (androids.position.y - dropDistance))
                nextMove = AndroidMove.Right
            } else {
                androids.position = CGPoint(x: (androids.position.x - stepDistance), y:androids.position.y)
            }
        } else if(nextMove == AndroidMove.Right) {
            if((CGRectGetMaxX(androidsFrame) + stepDistance) > CGRectGetMaxX(self.frame)) {
                androids.position = CGPoint(x: androids.position.x,y: (androids.position.y - dropDistance))
                nextMove = AndroidMove.Left
            } else {
                androids.position = CGPoint(x: (androids.position.x + stepDistance),y:androids.position.y)
            }
        }

        let revengeChance = 1 + Int(arc4random_uniform(UInt32(150 - 1 + 1)))

        if(currentTime - lastAndroidRetaliation > 3 && androids.children.count > 0)  {
            let punisherPosition = 0 + Int(arc4random_uniform(UInt32((androids.children.count - 1) - 0 + 1)))
            let bullet = makeBullet(BulletType.Android)
            feuerFrei(bullet, shooter: androids.children[punisherPosition] as SKNode)
            lastAndroidRetaliation = currentTime
        }
        self.lastAndroidsMovement = currentTime
    }

    enum BulletType {
        case Android, Apple
    }

    func makeBullet(type: BulletType) -> SKNode {
        var bullet: SKNode

        if(type == BulletType.Android) {
            bullet = SKSpriteNode(color: SKColor(rgba: "#1aec19"), size: CGSize(width: 2, height: 8))
        } else {
            bullet = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 2, height: 8))
        }

        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.mass = 0.2
        bullet.physicsBody?.friction = 0.0
        bullet.physicsBody?.linearDamping = 0
        bullet.physicsBody?.angularDamping = 0

        if(type == BulletType.Android) {
            bullet.physicsBody?.categoryBitMask = BodyType.AndroidBullet.rawValue
            bullet.physicsBody?.contactTestBitMask = BodyType.Player.rawValue
            bullet.physicsBody?.collisionBitMask = 0
        } else {
            bullet.physicsBody?.categoryBitMask = BodyType.PlayerBullet.rawValue
            bullet.physicsBody?.contactTestBitMask = BodyType.Android.rawValue
            bullet.physicsBody?.collisionBitMask = 0
        }

        return bullet
    }

    func feuerFrei(bullet: SKNode, shooter: SKNode) {
        //NSNotificationCenter.defaultCenter().postNotificationName("AllKilled", object: nil)
        if(bullet.physicsBody?.categoryBitMask == BodyType.PlayerBullet.rawValue) {
            bullet.position = CGPoint(x:CGRectGetMidX(shooter.frame),y:CGRectGetMaxY(shooter.frame))
            let impulseVector = CGVector(dx: 0, dy: (CGRectGetMaxY(self.frame) - CGRectGetMaxY(shooter.frame))/8)
            addChild(bullet)
            bullet.physicsBody?.applyImpulse(impulseVector)
        } else if(bullet.physicsBody?.categoryBitMask == BodyType.AndroidBullet.rawValue) {
            bullet.position = CGPoint(x:(shooter.parent!.position.x + CGRectGetMidX(shooter.frame)),y:(shooter.parent!.position.y + CGRectGetMinY(shooter.frame)))
            let impulseVector = CGVector(dx: 0, dy: (CGRectGetMinY(self.frame) - CGRectGetMaxY(shooter.frame))/8)
            addChild(bullet)
            bullet.physicsBody?.applyImpulse(impulseVector)
        }
    }

    var lastAppleCannonReload: CFTimeInterval = 0
    var appleCannonReloadDuration: CFTimeInterval = 1

    func fireAndReloadAppleCannon(currentTime: CFTimeInterval, player: SKNode) {
        if  ((currentTime - lastAppleCannonReload) < appleCannonReloadDuration) {
            return
        }
        let bullet = makeBullet(BulletType.Apple)
        feuerFrei(bullet, shooter: player)
        lastAppleCannonReload = currentTime
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "Explosion.sks")

        if(contact.bodyA.categoryBitMask == BodyType.AndroidBullet.rawValue || contact.bodyA.categoryBitMask == BodyType.PlayerBullet.rawValue) {
            explosion.position = contact.bodyA.node!.position
        } else {
            explosion.position = contact.bodyB.node!.position
        }


        self.addChild(explosion)

        if(contact.bodyA.categoryBitMask == BodyType.Player.rawValue) {
            playerKilled()
            contact.bodyB.node?.removeFromParent()
        } else if(contact.bodyB.categoryBitMask == BodyType.Player.rawValue) {
            playerKilled()
            contact.bodyA.node?.removeFromParent()
        } else if(contact.bodyA.categoryBitMask == BodyType.Android.rawValue || contact.bodyB.categoryBitMask == BodyType.Android.rawValue) {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            androidKilled()
        }
    }

    var lastTouch: CGPoint? = nil

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        lastTouch = touchLocation
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        lastTouch = touchLocation
    }

    // Be sure to clear lastTouch when touches end so that the impulses stop being applies
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        lastTouch = nil
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        updateAndroidsPosition(currentTime)
        // Based on: http://stackoverflow.com/questions/25277956/move-a-node-to-finger-using-swift-spritekit
        // Only add an impulse if there's a lastTouch stored
        let player = self.childNodeWithName("Player") as SKSpriteNode
        if let touch = lastTouch {
            fireAndReloadAppleCannon(currentTime, player: player)

            let impulseVector = CGVector(dx: (touch.x - player.position.x)/4, dy: 0)
            // If myShip starts moving too fast or too slow, you can multiply impulseVector by a constant or clamp its range
            player.physicsBody?.applyImpulse(impulseVector)
        } else if !player.physicsBody!.resting {
            // Adjust the -0.5 constant accordingly
            let impulseVector = CGVector(dx: player.physicsBody!.velocity.dx * -1.0,dy: 0)
            player.physicsBody?.applyImpulse(impulseVector)
        }
    }

    func androidKilled() {
        NSNotificationCenter.defaultCenter().postNotificationName("ScoreUpdate", object: nil)
        let androids = self.childNodeWithName("Androids") as SKNode!
        if(androids.children.isEmpty) {
            NSNotificationCenter.defaultCenter().postNotificationName("AllKilled", object: nil)
        }
    }

    func playerKilled() {
        NSNotificationCenter.defaultCenter().postNotificationName("LifesUpdate", object: nil)
    }

}
