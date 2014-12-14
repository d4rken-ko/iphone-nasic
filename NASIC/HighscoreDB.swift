//
//  HighscoreDB.swift
//  NASIC
//
//  Created by Matthias Urhahn on 14/12/14.
//  Copyright (c) 2014 M&M. All rights reserved.
//

import Foundation

struct ScoreEntry {
    var name: String
    var points: NSInteger
}

@objc class HighscoreDB : NSObject {

    var scoreBoard: Array<ScoreEntry> = Array()
    var dbPath: String

    let KEY_POINTS: String = "points"
    let KEY_NAME: String = "name"

    override init() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

        let documentsDirectory: AnyObject = paths[0]
        dbPath = documentsDirectory.stringByAppendingPathComponent("highscores.plist")

        let fileManager = NSFileManager.defaultManager()

        if (!fileManager.fileExistsAtPath(dbPath)) {
            let fileForCopy = NSBundle.mainBundle().pathForResource("highscores",ofType:"plist")
            fileManager.copyItemAtPath(fileForCopy!,toPath:dbPath, error: nil)
        }

        let scoreEntries = NSArray(contentsOfFile: dbPath)!

        for score in scoreEntries {
            let name = score[KEY_NAME] as String
            let points = score[KEY_POINTS] as NSInteger
            let scoreEntry = ScoreEntry(name: name, points: points);
            scoreBoard.append(scoreEntry)
        }
        scoreBoard.sort({ $0.points > $1.points })
    }

    func addScore(name: String, points: NSInteger) {
        var newEntry = ScoreEntry(name: name, points: points)
        scoreBoard.append(newEntry)
        commit()
    }

    func getEntry(position: NSInteger) -> ScoreEntry {
        return scoreBoard[position]
    }

    func getAllEntries() -> Array<ScoreEntry> {
        return scoreBoard;
    }

    func count() -> Int {
        return scoreBoard.count;
    }

    func isEmpty() -> Bool {
        return self.count() == 0;
    }

    func commit() {
        var toSave = NSMutableArray()
        for item in scoreBoard {
            var dicChild = NSMutableDictionary()
            dicChild.setValue(item.points, forKey:KEY_POINTS)
            dicChild.setValue(item.name, forKey:KEY_NAME)
            toSave.addObject(dicChild)
        }
        if(!toSave.writeToFile(dbPath, atomically:true)) {
            NSLog("ERROR saving");
        }
    }
    
}