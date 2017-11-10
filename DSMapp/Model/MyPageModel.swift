//
//  MyPageModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

struct MyPageModel: Codable{
    
    var stay_value: Int
    var name: String
    var extension_class: Int?
    var extension_seat: Int?
    var number: Int
    var goingout_sat: Bool
    var goingout_sun: Bool
    
}
