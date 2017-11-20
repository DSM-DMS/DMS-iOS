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
    var extension_11_class: Int?
    var extension_11_seat: Int?
    var extension_12_class: Int?
    var extension_12_seat: Int?
    var number: Int
    var goingout_sat: Bool
    var goingout_sun: Bool
    
}
