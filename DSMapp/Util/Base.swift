//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

    func showToast(msg: String){

        let toast = UILabel(frame: CGRect(x: 25, y: view.frame.size.height - 128, width: view.frame.size.width - 50, height: 35))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.text = msg
        toast.layer.cornerRadius = 16
        toast.clipsToBounds = true
        view.addSubview(toast)

        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: { _ in
            toast.removeFromSuperview()
        })

    }

    func connect(add: String, method: String, params: [String:String], fun: @escaping(Data?, Int?) -> Void){
        let url = "http://dsm2015.cafe24.com:3000"

        var paramStr = ""
        for param in params{
            paramStr += "\(param.key)=\(param.value)"
            paramStr += "&"
        }
        paramStr.removeFirst()

        var request: URLRequest? = nil
        if method == "GET" || method == "PUT"{
            request = URLRequest(url: URL(string: url + add + "?" +  paramStr)!)
        }else{
            request = URLRequest(url: URL(string: url + add)!)
            request?.httpBody = paramStr.data(using: .utf8)
        }
        request?.httpMethod = method

        let task = URLSession.shared.dataTask(with: request!){
            data, res, err in

            let httpRes = res as? HTTPURLResponse

            print(data)
            print(httpRes)

            fun(data, httpRes?.statusCode)

        }
        
        task.resume()
    }

}

enum Color{
    
    case CO1, CO2, CO3, CO4, CO5, CO6
    case YELLO, MINT
    
    func getColor() -> UIColor {
        switch self {
        case .CO1:
            return UIColor(red: 99/255, green: 160/255, blue: 191/255, alpha: 1)
        case .CO2:
            return UIColor(red: 117/255, green: 177/255, blue: 208/255, alpha: 1)
        case .CO3:
            return UIColor(red: 137/255, green: 185/255, blue: 209/255, alpha: 1)
        case .CO4:
            return UIColor(red: 167/255, green: 201/255, blue: 218/255, alpha: 1)
        case .CO5:
            return UIColor(red: 178/255, green: 212/255, blue: 230/255, alpha: 1)
        case .CO6:
            return UIColor(red: 219/255, green: 234/255, blue: 242/255, alpha: 1)
        case .YELLO:
            return UIColor(red: 255/255, green: 241/255, blue: 108/255, alpha: 1)
        case .MINT:
            return UIColor(red: 184/255, green: 232/255, blue: 215/255, alpha: 1)
        }
    }
    
}
