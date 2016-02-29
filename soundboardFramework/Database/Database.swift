//
//  Database.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 28/02/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import Foundation
import RealmSwift

class Soundboard: Object {
    dynamic var id: Int = 0
    dynamic var backgroundColor: String = ""
    dynamic var headerTitle: String = ""
    let audioFiles = List<AudioFile>()
    dynamic var buttonStyle: ButtonStyle?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AudioFile: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var url: String = ""
    dynamic var data: NSData?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ButtonStyle: Object {
    dynamic var id: Int = 0
    dynamic var backgroundColor: String = ""
    dynamic var cornerRadius: Float = 0
    var soundsboards: [Soundboard] {
        return linkingObjects(Soundboard.self, forProperty: "buttonStyle")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

}