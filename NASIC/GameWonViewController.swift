//
//  GameWonViewController.swift
//  NASIC
//
//  Created by Matthias Urhahn on 14/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import UIKit
import Foundation

class GameWonViewController: UIViewController{

    @IBOutlet weak var twiceThePowerButton: UIImageView!
    @IBOutlet weak var doubleBarreledButton: UIImageView!
    @IBOutlet weak var dubiosRewardButton: UIImageView!

    var level: NSInteger = 0 // Gets overriden by GameViewController

    override func viewDidLoad() {
        let tap1 = UITapGestureRecognizer(target: self, action: "onTwiceThePowerClicked")
        tap1.numberOfTapsRequired = 1
        twiceThePowerButton.addGestureRecognizer(tap1)
        twiceThePowerButton.userInteractionEnabled = true

        let tap2 = UITapGestureRecognizer(target: self, action: "onDoubleBarreledClicked")
        doubleBarreledButton.addGestureRecognizer(tap2)
        doubleBarreledButton.userInteractionEnabled = true

        let tap3 = UITapGestureRecognizer(target: self, action: "onDubiosRewardClicked")
        dubiosRewardButton.addGestureRecognizer(tap3)
        dubiosRewardButton.userInteractionEnabled = true

        super.viewDidLoad()
    }

    func onTwiceThePowerClicked() {
        continueGame()
    }

    func onDoubleBarreledClicked() {
        continueGame()
    }

    func onDubiosRewardClicked() {
        continueGame()
    }

    func continueGame() {
        let vc : GameViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GameView") as GameViewController
        vc.level = level
        presentViewController(vc, animated: true, completion: nil)
    }

}