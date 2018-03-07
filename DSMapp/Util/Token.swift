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
    
    func save(_ token: String, access: Bool = true){
        repo.set(token, forKey: access ? accessKey : refreshKey)
    }
    
    func remove(isAccess: Bool = true){
        repo.removeObject(forKey: isAccess ? accessKey : refreshKey)
    }
    
    func get(isAccess: Bool = true) -> String{
        guard let token = repo.string(forKey: isAccess ? accessKey : refreshKey) else{ return "" }
        return token
    }
    
}
