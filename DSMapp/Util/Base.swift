//
// Created by 이병찬 on 2017. 11. 4..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController{
    
    func getClassName(_ num: Int) -> String{
        let classNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실", "여자 자습실"]
        return classNameArr[num - 1]
    }
    
    func getStayStateName(_ num: Int) -> String{
        let stayStateNameArr = ["금요귀가", "토요귀가", "토요귀사", "잔류"]
        return stayStateNameArr[num - 1]
    }

    func showToast(msg: String, fun: (() -> Void)? = nil){
        let toast = UILabel(frame: CGRect(x: 32, y: 128, width: view.frame.size.width - 64, height: 42))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toast.textColor = UIColor.white
        toast.text = msg
        toast.textAlignment = .center
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true
        toast.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth]
        view.addSubview(toast)
        UIView.animate(withDuration: 0.2, delay: 0.8, options: .curveEaseOut, animations: {
            toast.alpha = 0.5
        }, completion: { _ in
            toast.removeFromSuperview()
            fun?()
        })
    }
    
    func showError(_ code: Int){
        showToast(msg: "오류 : \(code)")
    }
    
    func goNextViewController(_ id: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: id)
        present(vc!, animated: true, completion: nil)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func goNextViewWithStoryboard(storyId: String, id: String){
        let contentStoryboard = UIStoryboard.init(name: storyId, bundle: nil)
        let vc = contentStoryboard.instantiateViewController(withIdentifier: id)
        present(vc, animated: true, completion: nil)
    }
    
    func versionCheck() -> Disposable{
        let version = "1.0.7"
        return Connector.instance.request(createRequest(sub: "/version", method: .get, params: ["platform":"ios"]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                print(code)
                if code == 200{
                    let data = try! JSONDecoder().decode(VersionModel.self, from: data)
                    if data.newest_version != version{ self.showAlert() }
                }
            })
    public func loginCheck() -> Bool{
        let isLogin = Token.instance.get() != nil
        if !isLogin { showToast(msg: "로그인이 필요합니다") }
        return isLogin
    }
    
    private func showAlert(){
    private func showUpdateAlert(){
        let alert = UIAlertController(title: "업데이트가 필요합니다.", message: "DMS의 새로운 업데이트가 준비되었습니다.\n지금 업데이트 하세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

class VersionModel: Codable{
    
    let newest_version: String
    
}
