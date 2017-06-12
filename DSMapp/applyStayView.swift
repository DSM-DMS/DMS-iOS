//
//  applyStayView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 6. 11..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class applyStayView: UIViewController {

    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var friOut: UISwitch!
    @IBOutlet weak var satOut: UISwitch!
    @IBOutlet weak var satIn: UISwitch!
    @IBOutlet weak var stay: UISwitch!
    
    var switchArray = [UISwitch]()
    override func viewDidLoad() {
        super.viewDidLoad()
        switchArray = [friOut,satOut,satIn,stay]
        
        
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    override func viewWillAppear(_ animated: Bool) {
        var curruntNum = 0
        var check = false
        ap.getAPI(add: "/apply/stay", param: "", method: "GET", fun: {
            data, res, err in
            if err == nil{
                if res?.statusCode == 200{
                    curruntNum = (data as! [String:Int])["value"]!
                }
            }
            
            check = true
        })
        
        while !check {
            
        }
        
        for i in 0..<switchArray.count{
            if i == curruntNum - 1 {
                switchArray[i].setOn(true, animated: true)
            }else{
                switchArray[i].setOn(false, animated: true)
            }
        }
        
    }
    
    @IBAction func apply(_ sender: Any) {
    }
    
    @IBAction func valueChange(_ sender: Any) {
        let curruntSwitch = sender as! UISwitch
        if !curruntSwitch.isOn{
            stay.setOn(true, animated: true)
        }else{
            for i in switchArray{
                if i != curruntSwitch{
                    i.setOn(false, animated: true)
                }
            }
        }
    }
    

}
