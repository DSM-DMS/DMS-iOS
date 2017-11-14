//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func getClassName(_ num: Int) -> String{
        let classNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
        return classNameArr[num - 1]
    }
    
    func getStayStateName(_ num: Int) -> String{
        let stayStateNameArr = ["금요귀가", "토요귀가", "토요귀사", "잔류"]
        return stayStateNameArr[num - 1]
    }

    func showToast(msg: String){
        let toast = UILabel(frame: CGRect(x: 32, y: 128, width: view.frame.size.width - 64, height: 42))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        toast.textColor = UIColor.white
        toast.text = msg
        toast.textAlignment = .center
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true
        toast.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth]
        view.addSubview(toast)

        UIView.animate(withDuration: 2.0, delay: 0.3, options: .curveEaseOut, animations: {
            toast.alpha = 0.0
        }, completion: { _ in
            toast.removeFromSuperview()
        })
        
    }
    
    func goNextViewController(_ id: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: id)
        present(vc!, animated: true, completion: nil)
    }
    
    func connector(add: String, method: String, params: [String:String], fun: @escaping(Data?, Int) -> Void){
        let url = "http://dsm2015.cafe24.com:3000"

        var paramStr = ""
        for param in params{
            paramStr += "\(param.key)=\(param.value)"
            paramStr += "&"
        }
        if !paramStr.isEmpty{
            paramStr.removeLast()
        }

        var request: URLRequest? = nil
        if method == "GET" || method == "PUT"{
            request = URLRequest(url: URL(string: url + add + "?" +  paramStr)!)
        }else{
            request = URLRequest(url: URL(string: url + add)!)
            request?.httpBody = paramStr.data(using: .utf8)
        }
        
        if let token = getToken(){
            request?.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request?.httpMethod = method

        let task = URLSession.shared.dataTask(with: request!){
            data, res, err in

            let httpRes = res as? HTTPURLResponse

            DispatchQueue.main.async {
                if httpRes == nil{
                    self.showToast(msg: "네트워크 오류!")
                }else{
                    fun(data, httpRes!.statusCode)
                }
            }

        }
        
        task.resume()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func saveToken(_ token: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "token")
    }
    
    func removeToken(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "token")
    }
    
    func getToken() -> String?{
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "token")
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
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
