//
//  MealContentVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class MealContentVC: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var blackTextView: UITextView!
    @IBOutlet weak var lunchTextView: UITextView!
    @IBOutlet weak var dinnerTextView: UITextView!
    
    var date: Date? = nil
    
    override func viewDidLoad() {
        getData()
        setDateText()
    }
    
    func setDateText(){
        let fomatter = DateFormatter()
        fomatter.dateFormat = "YYYY"
        yearLabel.text = fomatter.string(from: date!)
        fomatter.dateFormat = "M월 d일"
        weekLabel.text = fomatter.string(from: date!)
        fomatter.dateFormat = "E"
        dayLabel.text = fomatter.string(from: date!)
    }
    
    func getData(){
        connector(add: "/meal/\(getDateAsStr())", method: "GET", params: [:], fun: {
            data, code in
            switch code{
            case 200:
                let decodeData = try! JSONDecoder().decode(MealModel.self, from: data!)
                self.blackTextView.text = self.getArrAsStr(arr: decodeData.breakfast)
                self.lunchTextView.text = self.getArrAsStr(arr: decodeData.lunch)
                self.dinnerTextView.text = self.getArrAsStr(arr: decodeData.dinner)
            case 204:
                self.blackTextView.text = "급식이 없습니다."
                self.lunchTextView.text = "급식이 없습니다."
                self.dinnerTextView.text = "급식이 없습니다."
            default:
                self.showToast(msg: "오류가 발생했습니다. : \(code)")
            }
        })
    }

}

extension MealContentVC{
    
    func getDateAsStr() -> String{
        let fomatter = DateFormatter()
        fomatter.dateFormat = "YYYY-MM-dd"
        return fomatter.string(from: date!)
    }
    
    func getArrAsStr(arr: Array<String>) -> String{
        var sendData = ""
        for i in arr{
            sendData += i
            sendData += ", "
        }
        sendData.removeLast()
        sendData.removeLast()
        
        return sendData
    }
    
}
