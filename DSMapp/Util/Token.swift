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
    private let key = "token"
    
    private init(){}
    
    func save(_ token: AuthModel){
        repo.set(token, forKey: key)
    }
    
    func remove(){
        repo.removeObject(forKey: key)
    }
    
    func get(isAccess: Bool = true) -> AuthModel?{
        return repo.object(forKey: key) as? AuthModel
    }
    
}
