//
//  UtilAPI.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 6. 8..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

public enum ReportAPI: API{
    
    case reportBug
    case reportFacility
    
    func getPath() -> String {
        switch self {
        case .reportBug: return "student/report/bug"
        case .reportFacility: return "student/report/facility"
        }
    }
    
}
