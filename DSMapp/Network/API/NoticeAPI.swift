//
//  NoticeAPI.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 6. 12..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation

public enum NoticeAPI: API{
    
    case getNoticeList(category: String)
    case getNoticeContent(category: String, postID: String)
    
    func getPath() -> String {
        switch self {
        case .getNoticeList(let category): return "post/\(category)"
        case .getNoticeContent(let category, let postID): return "post/\(category)/\(postID)"
        }
    }
    
}
