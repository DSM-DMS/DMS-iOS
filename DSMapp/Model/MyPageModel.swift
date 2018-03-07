//
//  MyPageModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

struct MyPageModel: Codable{
    
    let stay_value: Int
    let name: String
    let extension_11: Extension?
    let extension_12: Extension?
    let number: Int
    let goingout: GoingOut
    let good_point: Int
    let bad_point: Int
    
    func getStudyState() -> String{
        var stateStr = ""
        let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
        if extension_11 != nil{
            stateStr = "11 : \(roomNameArr[extension_11!.class_num - 1])"
        }else{
            stateStr = "11 : 신청 없음"
        }
        
        if extension_12 != nil{
            stateStr += "\n12 : \(roomNameArr[extension_12!.class_num - 1])"
        }else{
            stateStr += "\n12 : 신청 없음"
        }
        
        return stateStr
    }
    
    func getStayState() -> String{
        let stayStateArr = ["금요귀가", "토요귀가", "토요귀사", "잔류"]
        return stayStateArr[stay_value - 1]
    }
    
    struct GoingOut: Codable {
        var sat: Bool
        var sun: Bool
    }
    
    struct Extension: Codable {
        var seat_num: Int
        var class_num: Int
    }
    
    
}
