//
//  GameOverViewController.swift
//  NASIC
//
//  Created by Matthias Urhahn on 14/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import UIKit
import Foundation

class GameOverViewController: MyHelperViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    var highscoreDB: HighscoreDB = HighscoreDB()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onDoneClicked(sender: UIButton) {
        var name = nameField.text
        highscoreDB.addScore(name, points: delegate!.currentPoints)
        delegate!.goToHighscore()
    }

}