//
//  TodayViewController.swift
//  MealExtension
//
//  Created by 이병찬 on 2017. 11. 14..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var date = Date()
    var aDay = TimeInterval(86400)
    
    var dataArr = ["","",""]
    var timeArr = ["아침", "점심", "저녁"]
    
    var curTime = 0
    
    override func viewDidLoad() {
        curTime = 1
        getData()
    }
    
    @IBAction func before(_ sender: Any) {
        curTime -= 1
        setData()
    }
    
    @IBAction func after(_ sender: Any) {
        curTime += 1
        print(curTime)
        setData()
    }
    
    func setData(){
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
    
    func bind(){
        timeLabel.text = timeArr[curTime - 1]
        dataTextView.text = dataArr[curTime - 1]
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController{
    
    func getData(){
        let fommater = DateFormatter()
        fommater.dateFormat = "YYYY-MM-dd"
        dateLabel.text = fommater.string(from: date)
        var request = URLRequest(url: URL(string: "http://dsm2015.cafe24.com:3000/meal/\(fommater.string(from: date))")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){
            data, res, err in
            
            print(fommater.string(from: self.date))
            
            if err != nil{
                return
            }
            
            guard let httpRes = res as? HTTPURLResponse else{
                return
            }
            
            switch httpRes.statusCode{
            case 200:
                let decodeData = try! JSONDecoder().decode(MealModel.self, from: data!)
                self.dataArr[0] = self.arrToStr(decodeData.breakfast)
                self.dataArr[1] = self.arrToStr(decodeData.lunch)
                self.dataArr[2] = self.arrToStr(decodeData.dinner)
            case 204:
                self.dataArr = ["급식이 없습니다", "급식이 없습니다", "급식이 없습니다"]
            default:
                self.dataArr = ["오류 : \(httpRes.statusCode)", "오류 : \(httpRes.statusCode)", "오류 : \(httpRes.statusCode)"]
            }
            
            DispatchQueue.main.async {
                self.bind()
            }
            
        }.resume()
        
    }
    
    func arrToStr(_ data: [String]) -> String{
        var sendStr = ""
        for i in data{
            sendStr += (i + ", ")
        }
        sendStr.removeLast()
        sendStr.removeLast()
        
        return sendStr
    }
    
}
