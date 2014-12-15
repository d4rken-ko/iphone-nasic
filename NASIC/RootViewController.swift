//
//  RootViewController.swift
//  NASIC
//
//  Created by Matthias Urhahn on 15/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import Foundation
import UIKit

protocol AppComs {

    var currentLevel: Int {  get set }
    var currentPoints: Int {  get set }
    var currentLifes: Int {  get set }

    func goToGameWon()
    func goToGame()
    func goToGameOver()
    func goToHighscore()
}

class RootViewController: UIViewController, AppComs{

    var currentLevel: Int = 1
    var currentPoints: Int = 0
    var currentLifes: Int = 3

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    @IBAction func onPlayClicked(sender: AnyObject) {
        currentLevel = 1
        currentPoints = 0
        currentLifes = 3
        self.performSegueWithIdentifier("RootToGame", sender: self)
    }

    @IBAction func onHighscoreClicked(sender: AnyObject) {
        //self.performSegueWithIdentifier("RootToHighscore", sender: self)
        self.performSegueWithIdentifier("RootToLost", sender: self)
    }

    func goToGameWon() {
        dismissViewControllerAnimated(false, completion: {
            self.performSegueWithIdentifier("RootToWin", sender: self)
        })
    }

    func goToGameOver() {
        dismissViewControllerAnimated(false, completion: {
            self.performSegueWithIdentifier("RootToLost", sender: self)
        })
    }

    func goToGame() {
        dismissViewControllerAnimated(false, completion: {
                self.performSegueWithIdentifier("RootToGame", sender: self)
            })
    }

    func goToHighscore() {
        dismissViewControllerAnimated(false, completion: {
            self.performSegueWithIdentifier("RootToHighscore", sender: self)
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // get the controller that storyboard has instantiated and set it's delegate
        let secondController = segue!.destinationViewController as MyHelperViewController
        secondController.delegate = self;
    }

}