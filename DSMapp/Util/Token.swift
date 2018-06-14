//
//  Token.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 2. 14..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

class Token{
    
    static let instance = Token()
    private let repo = UserDefaults.standard
    private let accessKey = "access"
    private let refreshKey = "refresh"
    
    private init(){}
    
    func save(_ token: AuthModel){
        repo.set(token.accessToken, forKey: accessKey)
        repo.set(token.refreshToken!, forKey: refreshKey)
    }
    
    func changeAccessToken(_ token: String){
        repo.set(token, forKey: accessKey)
    }
    
    func remove(){
        repo.removeObject(forKey: accessKey)
        repo.removeObject(forKey: refreshKey)
    }
    
    func get() -> AuthModel?{
        let accessToken = repo.string(forKey: accessKey)
        let refreshToken = repo.string(forKey: refreshKey)
        if let at = accessToken, refreshToken != nil{ return AuthModel(accessToken: "JWT " + at, refreshToken: "JWT " + refreshToken!) }
        else{ return nil }
    }
    
}
