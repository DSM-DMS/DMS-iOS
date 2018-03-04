//
//  TodayViewController.swift
//  MealExtension
//
//  Created by 이병찬 on 2017. 11. 14..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import NotificationCenter
import RxSwift

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let formatter = DateFormatter()
    private let disposeBag = DisposeBag()
    
    private var date = Date()
    private let aDay = TimeInterval(86400)
    
    private var dataArr = ["","",""]
    private var timeStrArr = ["아침", "점심", "저녁"]
    
    private var curTime = 0
    
    override func viewDidAppear(_ animated: Bool) {
        setInit()
    }
    
    @IBAction func before(_ sender: Any) {
        curTime -= 1
        setData()
    }
    
    @IBAction func after(_ sender: Any) {
        curTime += 1
        setData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController{
    
    private func setInit(){
        formatter.dateFormat = "h"
        guard let curIntTime = Int(formatter.string(from: date)) else{ return }
        switch curIntTime {
        case 9...12:
            curTime = 2
        case 13...18:
            curTime = 3
        default:
            curTime = 1
        }
        getData()
    }
    
    private func setData(){
        switch curTime {
        case 0:
            date -= aDay
            curTime = 3
            getData()
        case 4:
            date += aDay
            curTime = 1
            getData()
        default:
            bind()
        }
    }
    
    private func getData(){
        formatter.dateFormat = "YYYY-MM-dd"
        dateLabel.text = formatter.string(from: date)
        var request = URLRequest(url: URL(string: "http://dsm2015.cafe24.com/meal/\(formatter.string(from: date))")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){
            data, res, err in
            if err != nil{ return }
            let code = (res as! HTTPURLResponse).statusCode
            switch code{
            case 200:
                let decodeData = try! JSONDecoder().decode(MealModel.self, from: data!)
                self.dataArr = decodeData.getData()
            case 204:
                self.dataArr = ["급식이 없습니다", "급식이 없습니다", "급식이 없습니다"]
            default:
                self.dataArr = ["오류 : \(code)", "오류 : \(code)", "오류 : \(code)"]
            }
            DispatchQueue.main.async { self.bind() }
        }.resume()
    }
    
    func bind(){
        timeLabel.text = timeStrArr[curTime - 1]
        dataTextView.text = dataArr[curTime - 1]
    }
    
}

class MealModel: Codable{
    
    let breakfast: [String]
    let lunch: [String]
    let dinner: [String]
    
    func getData() -> [String]{
        var dataArr = ["", "", ""]
        dataArr[0] = getStr(breakfast)
        dataArr[1] = getStr(lunch)
        dataArr[2] = getStr(dinner)
        return dataArr
    }
    
    private func getStr(_ arr: [String]) -> String{
        var dataStr = ""
        for i in arr{ dataStr += i + ", " }
        dataStr.removeLast(2)
        return dataStr
    }
    
}
