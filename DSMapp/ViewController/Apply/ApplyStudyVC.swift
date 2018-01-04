//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ApplyStudyVC: UIViewController  {

    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var changeRoomButton: UIButton!
    
    var selectedTime = 11
    var selectedClass = 1
    var selectedSeat = 0
    
    var beforeButton: UIButton? = nil
    var contentView: UIView? = nil
    
    @IBAction func pressBack(_ sender: Any) {
        back()
    }
    
    @IBAction func cancel(_ sender: ButtonShape) {
        connector(add: "/extension/\(selectedTime)", method: "DELETE", params: [:], fun: {
            _, code in
            if code == 200{
                self.showToast(msg: "취소 성공")
                self.getMap()
            }else{ self.showToast(msg: "오류 : \(code)") }
        })
    }
    
    let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
    
    @IBAction func apply(_ sender: Any) {
        if selectedSeat > 0{
            print(selectedTime, selectedClass, selectedSeat)
            connector(add: "/extension/\(selectedTime)", method: "POST", params: ["class_num" : "\(selectedClass)", "seat_num" : "\(selectedSeat)"], fun: {
                _, code in
                switch code{
                case 201:
                    self.showToast(msg: "신청 성공")
                    self.getMap()
                case 204:
                    self.showToast(msg: "신청 시간이 아닙니다")
                default:
                    self.showToast(msg: "오류 : \(code)")
                }
            })
        }else{
            showToast(msg: "자리를 선택하세요")
        }
    }
    
    override func viewDidLoad() {
        backScrollView.backgroundColor = Color.CO6.getColor()
        backScrollView.layer.cornerRadius = 8
        changeRoomButton.addTarget(self, action:
            #selector(changeRoom(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMap()
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            selectedTime = 11
        }else{
            selectedTime = 12
        }
        getMap()
    }
    
}

extension ApplyStudyVC{
    
    @objc func changeRoom(_ button: UIButton){
        let alert = UIAlertController(title: "방을 선택하세요.", message: nil, preferredStyle: .actionSheet)
        for i in roomNameArr{
            alert.addAction(UIAlertAction.init(title: i, style: .default, handler: alertClick(_:)))
        }
        alert.addAction(UIAlertAction.init(title: "닫기", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func alertClick(_ action: UIAlertAction){
        for i in 0..<roomNameArr.count{
            if action.title == roomNameArr[i]{
                changeRoomButton.setTitle(action.title, for: .normal)
                selectedClass = i+1
                getMap()
                return
            }
        }
    }
    
    func getMap(){
        selectedSeat = 0
        
        connector(add: "/extension/map/\(selectedTime)", method: "GET", params: ["class_num" : "\(selectedClass)"], fun: {
            data, code in
            switch code{
            case 200:
                self.bindData(try! JSONSerialization.jsonObject(with: data!, options: []) as! [[Any]])
            default:
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }
    
    func bindData(_ dataArr: [[Any]]){
        let width = dataArr[0].count * 65
        let height = dataArr.count * 65
        
        contentView?.removeFromSuperview()
        
        let tempX = backScrollView.frame.width - CGFloat(width)
        let tempY = backScrollView.frame.height - CGFloat(height)
        
        let setX = tempX > 0 ? tempX / 2 : 10
        let setY = tempY > 0 ? tempY / 2 : 10
        
        contentView = UIView.init(frame: CGRect.init(x: setX, y: setY, width: CGFloat(width), height: CGFloat(height)))
        
        var x = 0, y = 0
        
        for seatArr in dataArr{
            for seat in seatArr{
                if let titleInt = seat as? Int{
                    if titleInt > 0{
                        let button = getButton(x: x, y: y, title: "\(titleInt)")
                        button.setBackgroundImage(UIImage(named: "seatNo"), for: .normal)
                    }
                }else{
                    let button = getButton(x: x, y: y, title: seat as! String)
                    button.setBackgroundImage(UIImage(named: "seatYes"), for: .normal)
                }
                x += 65
            }
            x = 0
            y += 65
        }
        
        backScrollView.contentSize = CGSize.init(width: width + 10, height: height + 10)
        backScrollView.addSubview(contentView!)
    }
    
    func getButton(x: Int, y: Int, title: String) -> UIButton{
        let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: 55, height: 55))
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        
        contentView?.addSubview(button)
        
        return button
    }
    
    @objc func onClick(_ button: UIButton){
        if let intTitle = Int(button.title(for: .normal)!){
            beforeButton?.setBackgroundImage(UIImage.init(named: "seatNo"), for: .normal)
            button.setBackgroundImage(UIImage.init(named: "seatSelect"), for: .normal)
            selectedSeat = intTitle
            beforeButton = button
        }else{
            showToast(msg: "자리가 있습니다")
        }
    }
    
    
}
