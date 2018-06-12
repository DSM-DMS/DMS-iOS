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
import Alamofire

public class Connector{
    
    public static let instance = Connector()
    
    private let basePath = "http://dsm2015.cafe24.com/v2/"
    private init(){ }
    
    func getRequest(_ subPath: API, method: RequestMethod, params: [String : String]? = nil) -> URLRequest{
        var urlStr = basePath + subPath.getPath()
        
        if method == .get{
            var query = params?.map{ "\($0)=\($1)" }.reduce(""){ f, s -> String in "\(f)&\(s)" } ?? ""
            if !query.isEmpty{ query.removeFirst(); urlStr += ("?" + query) }
        }
        
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = method.rawValue
        
        if method != .get, params != nil{
            let jsonData = try? JSONSerialization.data(withJSONObject: params!)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = Token.instance.get() {
            request.addValue(token.accessToken, forHTTPHeaderField: "authorization")
        }
        
        return request
    }
    
}

public extension URLRequest{
    
    func getDataForMap(vc: UIViewController) -> Observable<(Int, Any?)>{
        return requestData(self)
            .map{ ($0.0.statusCode, $0.1) }
            .map{ (code, data) in
                let decodeData = try? JSONSerialization.jsonObject(with: data, options: [])
                return (code, decodeData)
            }
    }
    
    func emptyData(vc: UIViewController) -> Observable<Int>{
        return decodeData(String.self, vc: vc).map{ $0.0 }
    }
    
    func decodeData<T>(_ type: T.Type ,vc: UIViewController) -> Observable<(Int, T?)> where T: Decodable{
        return requestData(self)
            .single()
            .map{ ($0.0.statusCode, $0.1) }
            .map{ (code, data) in
                let decodeData = try? JSONDecoder().decode(type, from: data)
                return (code, decodeData)
            }
            .filter{ (code, _) in
                if code == 500{ vc.showToast(msg: "서버 오류") }
                return code != 500
            }
    }
    
}

public enum RequestMethod: String{
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    
}
