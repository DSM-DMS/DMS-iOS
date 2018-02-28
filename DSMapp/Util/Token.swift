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
    private let tokenID = "0903"
    
    private init(){}
    
    func save(_ token: String){
        repo.set(token, forKey: tokenID)
    }
    
    func remove(){
        repo.removeObject(forKey: tokenID)
    }
    
    func get() -> String{
        guard let token = repo.string(forKey: tokenID) else{ return "" }
        return token
    }
    
}
