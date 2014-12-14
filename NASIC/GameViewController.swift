//
//  GameViewController.swift
//  NASIC
//
//  Created by Matthias Urhahn on 06/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lifesLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!

    var lifes = 3;
    var score = 0;
    var level = 10;
    var highScore = 0;

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.size = skView.bounds.size
            scene.scaleMode = .AspectFill
            scene.difficultyMultiplier = level
            
            skView.presentScene(scene)

            levelLabel.text = "Level\n" + String(level)
            lifesLabel.text = "Lifes\n" + String(lifes)
            highScoreLabel.text = "Highscore\n" + String(highScore)
            scoreLabel.text = "Score\n" + String(score)

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScore:", name:"ScoreUpdate", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLifes:", name:"LifesUpdate", object: nil)
        }
    }

    func updateLifes(notification: NSNotification) {
        lifes--;
        lifesLabel.text = "Lifes\n" + String(lifes)
    }

    func updateScore(notification: NSNotification) {
        score++;
        scoreLabel.text = "Score\n" + String(score)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
