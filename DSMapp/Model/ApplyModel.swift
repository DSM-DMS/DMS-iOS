//
//  ApplyModel.swift
//  DSMapp
//
//  Created by 이병찬 on 31/05/2018.
//  Copyright © 2018 이병찬. All rights reserved.
//

import Foundation

public struct ApplyModel: Codable{
    
    static let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실", "여자 자습실"]
    static let stayStateArr = ["금요귀가", "토요귀가", "토요귀사", "잔류"]
    
    let extension_11: Extension?
    let extension_12: Extension?
    let goingout: GoingOut
    let stay: Int
    
    struct GoingOut: Codable {
        var sat: Bool
        var sun: Bool
    }
    
    struct Extension: Codable {
        var class_num: Int
    }
    
    func getStudyState() -> String{
        let getData = { (_ data: Extension?) -> String in
            guard let data = data else{ return "신청 없음" }
            return ApplyModel.roomNameArr[data.class_num]
        }
        
        return "11 : \(getData(extension_11))\n12 : \(getData(extension_12))"
    }
    
    func getStayState() -> String{
        return ApplyModel.stayStateArr[stay - 1]
    }
    
}
