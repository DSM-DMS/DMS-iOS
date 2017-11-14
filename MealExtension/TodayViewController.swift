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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
    
    func bind(){
        var request = URLRequest.init(url: URL(string: "")!)
        request.httpMethod = "GET"
        
        URLSession().dataTask(with: request){
            data, res, err in
            
            DispatchQueue.main.async {
                
            }
            
        }.resume()
        
    }
    
}
