//
//  DataBaseClass.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 7. 5..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation
import RealmSwift

class mealData : Object{
    dynamic var breakfast = ""
    dynamic var lunch = ""
    dynamic var dinner = ""
    
    dynamic var date = ""
    
    override static func primaryKey() -> String?{
        return "date"
    }
}

class loginData : Object{
    dynamic var id = ""
    dynamic var pw = ""
    
}
