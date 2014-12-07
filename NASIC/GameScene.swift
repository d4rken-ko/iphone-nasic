//
//  GameScene.swift
//  NASIC
//
//  Created by Matthias Urhahn on 06/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {




    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        backgroundColor = SKColor(rgba: "#2D2D2D")

        let player = SKSpriteNode(imageNamed: "apple_rotated1")
        player.name = "Player"
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame)+player.frame.height+10);
        player.runAction(SKAction.scaleBy(0.5, duration: 0))
        addChild(player)

      //  let testBlock = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: self.frame.width - 5, height: self.frame.height - 5))
      //  testBlock.position = CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
      //  addChild(testBlock)

        let androidBlock = makeAndroidBlock()
        addChild(androidBlock)
    }


    func makeAndroidBlock() -> SKNode {
        let _androidBlock = SKNode()
        _androidBlock.name = "Androids"
        for column in 1...6 {
            for row in 1...5 {
                let android = SKSpriteNode(imageNamed: "android_head1")
                android.name = "Android"
                android.runAction(SKAction.scaleBy(0.5, duration: 0))
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
    var lastAndroidsMovement  = 0 as CFTimeInterval
    let stepDistance = 1 as CGFloat
    let dropDistance = 4 as CGFloat

    func updateAndroidsPosition(currentTime: CFTimeInterval) {
        if  ((currentTime - lastAndroidsMovement) < 0.01 as CFTimeInterval) {
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
        self.lastAndroidsMovement = currentTime
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        updateAndroidsPosition(currentTime)
    }
}
