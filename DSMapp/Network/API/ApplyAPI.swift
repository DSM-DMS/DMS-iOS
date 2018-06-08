//
//  ApplyAPI.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 6. 8..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

public enum ApplyAPI: API{
    
    case applyOrCancelExtensionInfo(time: Int)
    case getExtensionMapInfo(time: Int)
    case applyOrGetStayInfo
    case applyOrGetGoingOutInfo
    
    func getPath() -> String {
        switch self {
        case .getExtensionMapInfo(let time): return "student/apply/extension/\(time)/map"
        case .applyOrCancelExtensionInfo(let time): return "student/apply/extension/\(time)"
        case .applyOrGetStayInfo: return "student/apply/stay"
        case .applyOrGetGoingOutInfo: return "student/apply/goingout"
        }
    }
    
}
