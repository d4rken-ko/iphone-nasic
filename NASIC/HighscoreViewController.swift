//
//  HighscoreViewController.swift
//  NASIC
//
//  Created by Matthias Urhahn on 14/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import UIKit
import Foundation

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var highscoreTable: UITableView!
    var highscoreDB: HighscoreDB = HighscoreDB()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.highscoreTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highscoreDB.count();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.highscoreTable.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let entry = self.highscoreDB.getEntry(indexPath.row)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.text = String(indexPath.row + 1) + ": " + entry.name + "     " + String(entry.points)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
    
}