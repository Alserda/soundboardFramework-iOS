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
    dynamic var backgroundImageURL: String? = nil
    dynamic var backgroundImage: NSData? = nil
    dynamic var headerTitle: String = ""
    let audioButtons = List<AudioButton>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AudioButton: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var url: String = ""
    dynamic var data: NSData?
    dynamic var x: Float = 0
    dynamic var y: Float = 0
    dynamic var width: Float = 0
    dynamic var height: Float = 0
    dynamic var buttonStyle: ButtonStyle?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ButtonStyle: Object {
    dynamic var id: Int = 0
    dynamic var backgroundColor: String = ""
    dynamic var backgroundColorHighlighted: String = ""
    dynamic var bottomBorderColor: String = ""
    dynamic var cornerRadius: Float = 0
    dynamic var fontColor: String = ""
    dynamic var fontFamily: String = ""
    dynamic var fontSize: Int = 15
    dynamic var fontStyle: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}