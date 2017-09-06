//
//  applyStudyView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 6. 13..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class ApplyStudyView: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var curruntMap = [[Any]]()
    var curruntSelect = String()
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
        for i in 0..<roomName.count{
            if roomName[i] == roomChangeButton.title(for: .normal){
                ap.getAPI(add: "/apply/extension", param: "class=\(i + 1)&seat=\(Int(curruntSelect)!)", method: "PUT",fun: {
                    data, res, err in
                    if err == nil{
                        if res?.statusCode == 200{
                            DispatchQueue.main.async {
                                self.getData(i + 1)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.showToast(message: "신청 시간이 아닙니다.")
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showToast(message: "네트워크를 확인하십시오.")
                        }
                    }
                })
            }
        }
        
    }
    
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        applyButton.layer.shadowOffset =  CGSize.init(width: 2, height: 2)
        applyButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        scrollView.layer.cornerRadius = 10
        scrollView.backgroundColor = UIColor.init(red: 241/255, green: 249/255, blue: 252/255, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData(1)
    }
    
    func draw(_ map: [[Any]], beforeName: String = "-1"){
        let widthLenth = map[0].count
        let heigthLenth = map.count
        
        let dataY = scrollView.frame.height / 2 - CGFloat.init(Float(heigthLenth) / 2 * 60.0)
        let dataX = scrollView.frame.width / 2 - CGFloat.init(Float(widthLenth) / 2 * 60.0)
        var y =  dataY >= 0 ?  dataY : 0
        var x = dataX >= 0 ? dataX : 0
        for drawY in map{
            x = dataX >= 0 ? dataX : 0
            for name in drawY{
                if let insertButton = makeButton(x: x, y: y, name: name, beforeName: beforeName){
                    self.scrollView.addSubview(insertButton)
                }
                x += 60
            }
            y += 60
        }
        
        scrollView.contentSize = CGSize.init(width: CGFloat.init(widthLenth * 60), height: CGFloat.init(heigthLenth * 60))
    }
    
    func makeButton(x: CGFloat,y: CGFloat, name: Any, beforeName: String)-> UIButton?{
        let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: 55, height: 55))
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(seatClicked(_:)), for: .touchUpInside)
        if let seatNum = (name as? Int){
            if seatNum == Int(beforeName)!{
                button.setBackgroundImage(UIImage.init(named: "seatSelect.png"), for: .normal)
                button.setTitle("?", for: .normal)
                return button
            }
            if seatNum == 0{
                return nil
            }
            button.setBackgroundImage(UIImage.init(named: "seatNo.png"), for: .normal)
            button.setTitle("\(seatNum)", for: .normal)
        }else if let seatName = (name as? String){
            print(ap.userName)
            if seatName == ap.userName{
                button.setBackgroundImage(UIImage.init(named: "mySeat.png"), for: .normal)
                return button
            }
            button.setBackgroundImage(UIImage.init(named: "seatYes.png"), for: .normal)
            button.setTitle(seatName, for: .normal)
        }
        
        return button
    }
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    func seatClicked(_ sender: UIButton){
        if sender.title(for: .normal) == nil || sender.title(for: .normal) == "?"{
            return
        }
        curruntSelect = sender.title(for: .normal)!
        changeMap(curruntSelect)
    }
    
    
    let roomName = ["가온실","나온실","다온실","라온실","3층 독서실","4층 독서실","열린교실"]
    
    @IBAction func roomChange(_ sender: Any) {
        let alert = UIAlertController.init(title: "연장실 변경", message: "방을 선택하세요" , preferredStyle: .actionSheet)
        for i in roomName{
            alert.addAction(UIAlertAction.init(title: i, style: .default, handler: alertClicked(_:)))
        }
        alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func changeMap(_ name: String){
        for temp in scrollView.subviews{
            temp.removeFromSuperview()
        }
        self.draw(curruntMap, beforeName: name)
    }
    
    @IBOutlet weak var roomChangeButton: UIButton!
    
    func alertClicked(_ sender: UIAlertAction){
        for i in 0..<self.roomName.count{
            if self.roomName[i] == sender.title{
                roomChangeButton.setTitle(sender.title, for: .normal)
                for temp in scrollView.subviews{
                    temp.removeFromSuperview()
                }
                self.getData(i + 1)
                break
            }
        }
        showToast(message: "자리 로딩 완료")
    }
    
    func getData(_ num: Int){
        ap.getAPI(add: "apply/extension/class", param: "class=\(num)&option=map", method: "GET", fun: {
            data, res, err in
            if err == nil{
                if res?.statusCode == 200{
                    let temp1 = data as! [String : Any]
                    let map = temp1["map"] as! [[Any]]
                    DispatchQueue.main.async {
                        self.curruntMap = map
                        self.draw(map)
                    }
                }
            }
            
        })
    }

}
