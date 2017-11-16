//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ApplyStudyVC: UIViewController  {
    
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var changeRoomButton: UIButton!
    
    var contentView: UIView? = nil
    var selectedTime = 11
    
    
    @IBAction func pressBack(_ sender: Any) {
        back()
    }
    
    let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
    
    @IBAction func apply(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMap(1)
    }
    
    override func viewDidLoad() {
        changeRoomButton.addTarget(self, action:
            #selector(changeRoom(_:)), for: .touchUpInside)
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        if sender.numberOfSegments == 0{
            selectedTime = 11
        }else{
            selectedTime = 12
        }
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
                getMap(i + 1)
                return
            }
        }
    }
    
    func getMap(_ classNum : Int){
        connector(add: "/extension/map/\(selectedTime)", method: "GET", params: ["class" : "\(classNum)"], fun: {
            data, code in
            if code == 200{
                print(String.init(data: data!, encoding: .utf8))
                let map = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[Any]]
                self.bind(map)
            }else{
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }
    
    func bind(_ map: [[Any]]){
        var x = 0, y = 0
        
        let width = map[0].count * 65
        let heigth = map.count * 65
        
        backScrollView.contentSize = CGSize.init(width: width, height: heigth)
        
        contentView?.removeFromSuperview()
        
        contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: heigth))
        
        for seatList in map{
            for seat in seatList{
                if let seatNum = seat as? Int{
                    if seatNum != 0{
                        let button = addButton(x: x, y: y, name: "\(seatNum)")
                        button.setBackgroundImage(UIImage.init(named: "seatNo"), for: .normal)
                        contentView?.addSubview(button)
                    }
                }else{
                    let button = addButton(x: x, y: y, name: seat as! String)
                    button.setBackgroundImage(UIImage.init(named: "seatYes"), for: .normal)
                    contentView?.addSubview(button)
                }
                x += 65
            }
            x = 0
            y += 65
        }
        
        backScrollView.addSubview(contentView!)
    }
    
    func addButton(x: Int, y: Int, name: String) -> UIButton{
        let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: 55, height: 55))
        button.setTitle(name, for: .normal)
        return button
    }
    
    
}
