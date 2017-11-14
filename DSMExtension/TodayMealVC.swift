//
//  TodayViewController.swift
//  DSMExtension
//
//  Created by 이병찬 on 2017. 8. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayMealVC: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dataTextView: UITextView!
    
    @IBAction func before(_ sender: Any) {
        
    }
    
    @IBAction func after(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayMealVC{
    
    func getStrToArr(_ arr: [String]) -> String{
        var sendStr = ""
        for(data in arr){
            sendStr += "\(data), "
        }
        
        sendStr.removeLast()
        sendStr.removeLast()
        
        return sendStr
    }
    
    func bind(){
        let request = URLRequest.init(url: URL(string: " http://dsm2015.cafe24.com:3000/meal/\()")!)
        
    }
}
