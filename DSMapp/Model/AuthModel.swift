//
//  AuthModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 11..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

struct AuthModel: Codable{
    let accessToken: String
    let refreshToken: String?
}
