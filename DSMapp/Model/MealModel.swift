//
//  MealModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

public class MealModel: Codable{
    
    let breakfast: [String]
    let lunch: [String]
    let dinner: [String]
    
    func getData() -> [String]{
        var dataArr = ["", "", ""]
        dataArr[0] = getStr(breakfast)
        dataArr[1] = getStr(lunch)
        dataArr[2] = getStr(dinner)
        return dataArr
    }
    
    private func getStr(_ arr: [String]) -> String{
        var dataStr = ""
        for i in arr{ dataStr += i + ", " }
        dataStr.removeLast(2)
        return dataStr
    }
    
}
