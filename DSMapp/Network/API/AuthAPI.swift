//
//  API.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 6. 8..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

public enum AuthAPI: API{
    
    case refreshAccessToken
    case signIn
    case signUp
    case verifyID
    case verifyUUID
    case changePassWord
    
    func getPath() -> String {
        switch self {
        case .refreshAccessToken: return "jwt/refresh"
        case .signIn: return "student/auth"
        case .signUp: return "student/signup"
        case .verifyID: return "student/verify/id"
        case .verifyUUID: return "student/verify/uuid"
        case .changePassWord: return "student/account/change-pw"
        }
    }
    
}
