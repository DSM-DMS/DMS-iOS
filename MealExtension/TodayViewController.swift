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
    
    private var date: Date!
    private let aDay = TimeInterval(86400)
    
    private var data = [String]()
    
    private var currentTime = 0
    
    override func viewDidLoad() {
        date = Date()
        setInit()
    }
    
    @IBAction func before(_ sender: Any) {
        currentTime -= 1
        setData()
    }
    
    @IBAction func after(_ sender: Any) {
        currentTime += 1
        setData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController{
    
    private func setInit(){
        formatter.dateFormat = "H"
        guard let curIntTime = Int(formatter.string(from: date)) else{ return }
        switch curIntTime {
        case 0...8:
            currentTime = 0
        case 9...12:
            currentTime = 1
        case 13...17:
            currentTime = 2
        default:
            date! += aDay
            currentTime = 0
        }
        getData()
    }
    
    private func setData(){
        switch currentTime {
        case -1:
            date! -= aDay
            currentTime = 2
            getData()
        case 3:
            date! += aDay
            currentTime = 0
            getData()
        default:
            bind()
        }
    }
    
    private func getData(){
        formatter.dateFormat = "YYYY-MM-dd"
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        _ = Connector.instance
            .getRequest(InfoAPI.getMealInfo(date: dateStr), method: .get)
            .decodeData(MealModel.self)
            .subscribe(onNext: { [weak self] code, data in
                guard let strongSelf = self else { return }
                switch code{
                case 200: strongSelf.data = data!.getDataForExtension()
                case 204: strongSelf.data = ["급식이 없습니다", "급식이 없습니다", "급식이 없습니다"]
                default: strongSelf.data = ["오류 : \(code)", "오류 : \(code)", "오류 : \(code)"]
                }
                strongSelf.bind()
            })
    }
    
    func bind(){
        print(currentTime)
        timeLabel.text = ["아침", "점심", "저녁"][currentTime]
        dataTextView.text = data[currentTime]
    }
    
}
