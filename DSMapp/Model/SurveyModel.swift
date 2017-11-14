//
//  SurveyModel.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 12..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import Foundation

class SurveyModel: Codable{
    
    var title: String
    var is_objective: Bool
    var choice_paper: Array<String>?
    var id: String
    
}
