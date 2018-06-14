//
//  MealModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 8..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

public typealias MealTuple = (breakfast: String, lunch: String, dinner: String)

public struct MealModel: Codable{
    
    let breakfast: [String]
    let lunch: [String]
    let dinner: [String]
    
    func getData() -> MealTuple{
        return (getStr(breakfast), getStr(lunch), getStr(dinner))
    }
    
    func getDataForExtension() -> [String]{
        return [getStr(breakfast), getStr(lunch), getStr(dinner)]
    }
    
    private func getStr(_ arr: [String]) -> String{
        var data = arr.map{ $0 + ", " }.reduce(""){ $0 + $1 }
        data.removeLast(2)
        return data
    }
    
}
