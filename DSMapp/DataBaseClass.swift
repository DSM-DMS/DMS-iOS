//
//  DataBaseClass.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 7. 5..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation
import RealmSwift

class LoginData : Object{
    dynamic var name = ""
    dynamic var domain = ""
    dynamic var value = ""
    dynamic var path = ""
}
