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

class GameViewController: MyHelperViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lifesLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!

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
            scene.difficultyMultiplier = delegate!.currentLevel
            
            skView.presentScene(scene)

            let db = HighscoreDB()
            let highScore = db.getHighScore()

            levelLabel.text = "Level\n" + String(delegate!.currentLevel)
            lifesLabel.text = "Lifes\n" + String(delegate!.currentLifes)
            highScoreLabel.text = "Highscore\n" + String(highScore)
            scoreLabel.text = "Score\n" + String(delegate!.currentPoints)

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateScore:", name:"ScoreUpdate", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLifes:", name:"LifesUpdate", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameWon:", name:"AllKilled", object: nil)
        }
    }

    func gameWon(notification: NSNotification) {
        delegate?.currentLevel = 1 + delegate!.currentLevel
        if(delegate!.currentLevel % 3 == 0) {
            delegate?.goToGameWon()
        } else {
            delegate?.goToGame()
        }

    }

    func updateLifes(notification: NSNotification) {
        if(delegate!.currentLifes == 0) {
            delegate?.goToGameOver()
        } else {
            delegate!.currentLifes--;
            lifesLabel.text = "Lifes\n" + String(delegate!.currentLifes)
        }
    }

    func updateScore(notification: NSNotification) {
        delegate?.currentPoints = 1 + delegate!.currentPoints
        delegate?.levelPoints = 1 + delegate!.levelPoints
        scoreLabel.text = "Score\n" + String(delegate!.currentPoints)
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

    @IBAction func onBackClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
