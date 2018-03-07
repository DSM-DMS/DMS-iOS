//
//  SurveyModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 12..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

class SurveyModel: Codable{
    
    let title: String
    let is_objective: Bool
    let choice_paper: Array<String>?
    let id: String
    
}
