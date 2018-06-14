//
//  InfoAPI.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 6. 8..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

public enum InfoAPI: API{
    
    case getApplyInfo
    case getMypageInfo
    case getPointInfo
    case getVersionInfo
    
    case getMealInfo(date: String)
    
    func getPath() -> String {
        switch self {
        case .getVersionInfo: return "metadata/version/3"
        case .getMealInfo(let date): return "meal/\(date)"
        case .getApplyInfo: return "student/info/apply"
        case .getPointInfo: return "student/info/point-history"
        case .getMypageInfo: return "student/info/mypage"
        }
    }
    
}
