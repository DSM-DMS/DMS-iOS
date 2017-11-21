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
    
    func getStudyState() -> String{
        var stateStr = ""
        let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
        if extension_11_class != nil{
            stateStr = "11: \(roomNameArr[extension_11_class! - 1])-\(extension_11_seat!)"
        }else{
            stateStr = "11: 신청 없음"
        }
        
        if extension_11_class != nil{
            stateStr += "\n12: \(roomNameArr[extension_12_class! - 1])-\(extension_12_seat!)"
        }else{
            stateStr += "\n12: 신청 없음"
        }
        
        return stateStr
    }
    
    
}
