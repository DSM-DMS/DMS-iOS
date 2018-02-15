//
//  Connector.swift
//  DSMapp
//
//  Created by 이병찬 on 2018. 2. 14..
//  Copyright © 2018년 이병찬. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class Connector{
    
    static let instance = Connector()
    
    private init(){ }
    
    func request(_ req: URLRequest, vc: UIViewController) -> Observable<(Int, Data)>{
        return requestData(req)
            .flatMapLatest{ return Observable.just(($0.0.statusCode, $0.1)) }
            .filter{ code, _ in
                switch code{
                case 500:
                    vc.showToast(msg: "서버 오류")
                    return false
                case 422:
                    vc.showToast(msg: "다시 로그인 하세요")
                    return false
                case 401:
                    vc.showToast(msg: "로그인이 필요합니다")
                    return false
                default:
                    return true
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
}

extension UIViewController{
    
    func createRequest(sub: String, method: RequestMethod, params: [String : String]) -> URLRequest{
        var urlStr = "http://dsm2015.cafe24.com" + sub
        var dataStr = ""
        for param in params{ dataStr += param.key + "=" + param.value + "&" }
        if !dataStr.isEmpty{ dataStr.removeLast() }
        if method == .get{ urlStr += "?" + dataStr }
        var request = URLRequest(url: URL(string: urlStr)!)
        if method != .get{ request.httpBody = dataStr.data(using: .utf8) }
        request.httpMethod = method.rawValue
        let token = Token.instance
        if !token.get().isEmpty{ request.addValue("JWT \(token.get())", forHTTPHeaderField: "Authorization") }
        return request
    }
    
}

enum RequestMethod: String{
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    
}
