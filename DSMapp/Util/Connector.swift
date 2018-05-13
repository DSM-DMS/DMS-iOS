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

public class Connector{
    
    static let instance = Connector()
    
    private init(){ }
    
    func request(_ req: URLRequest, vc: UIViewController, check401: Bool = true) -> Observable<(Int, Data)>{
        return requestData(req)
            .map{ ($0.0.statusCode, $0.1) }
            .filter{ code, _ in
                if code == 401 && check401{
                    vc.showToast(msg: "로그인이 필요합니다")
                    Token.instance.remove()
                    return false
                }
                switch code{
                case 500:
                    vc.showToast(msg: "서버 오류")
                    return false
                case 403: vc.showToast(msg: "권한이 없습니다")
                    return false
                case 422:
                    vc.showToast(msg: "다시 로그인 하세요")
                    Token.instance.remove()
                    return false
                default:
                    return true
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
}

public extension UIViewController{
    
    func createRequest(sub: String, method: RequestMethod, params: [String : String], isAccess: Bool = true) -> URLRequest{
        var urlStr = "http://dsm2015.cafe24.com" + sub
        var dataStr = ""
        for param in params{ dataStr += param.key + "=" + param.value + "&" }
        if !dataStr.isEmpty{ dataStr.removeLast() }
        if method == .get{ urlStr += "?" + dataStr }
        var request = URLRequest(url: URL(string: urlStr)!)
        if method != .get{ request.httpBody = dataStr.data(using: .utf8) }
        request.httpMethod = method.rawValue
        let tokenInstance = Token.instance
        let token = tokenInstance.get(isAccess: isAccess)
        if !token.isEmpty{ request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization") }
        return request
    }
    
}

public enum RequestMethod: String{
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    
}
