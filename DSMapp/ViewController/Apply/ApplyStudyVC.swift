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
    
    @IBAction func pressBack(_ sender: Any) {
        back()
    }
    
    let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
    
    @IBAction func apply(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        backScrollView.backgroundColor = Color.CO6.getColor().withAlphaComponent(0.5)
        backScrollView.layer.cornerRadius = 8
        changeRoomButton.addTarget(self, action:
            #selector(changeRoom(_:)), for: .touchUpInside)
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
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
                selectedClass = i+1
                return
            }
        }
    }
    
    func getMap(){
        connector(add: "/extension/\(selectedTime)", method: "GET", params: ["class" : "\(selectedClass)"], fun: {
            data, code in
            switch code{
            case 200:
                self.showToast(msg: "로드 성공")
                self.bindData(try! JSONSerialization.jsonObject(with: data!, options: []) as! [[Any]])
            default:
                self.showToast(msg: "오류 : \(code)")
            }
        })
    }
    
    func bindData(_ dataArr: [[Any]]){
        let width = dataArr[0].count * 65
        let height = dataArr.count * 65
        
        let tempX = backScrollView.frame.width - CGFloat(width)
        let tempY = backScrollView.frame.height - CGFloat(height)
        
        let setX = tempX > 0 ? tempX : 10
        let setY = tempY > 0 ? tempY : 10
        
        let contentView = UIView.init(frame: CGRect.init(x: setX, y: setY, width: CGFloat(width), height: CGFloat(height)))
        
        var x = 0, y = 0
        
        for seatArr in dataArr{
            for seat in seatArr{
                let button = getButton(x: x, y: y, title: seat as! String)
                if let titleInt = seat as? Int, titleInt > 0{
                    button.setBackgroundImage(UIImage(named: "seatNo"), for: .normal)
                }else{
                    button.setBackgroundImage(UIImage(named: "seatYes"), for: .normal)
                }
                x += 65
            }
            y += 65
        }
        
        backScrollView.contentSize = CGSize.init(width: width + 10, height: height + 10)
        backScrollView.addSubview(contentView)
    }
    
    func getButton(x: Int, y: Int, title: String) -> UIButton{
        let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: 55, height: 55))
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func onClick(_ button: UIButton){
        if let intTitle = button.title(for: .normal) as? Int{
            beforeButton?.setBackgroundImage(UIImage.init(named: "seatNo"), for: .normal)
            button.setBackgroundImage(UIImage.init(named: "seatSelect"), for: .normal)
            selectedSeat = intTitle
        }else{
            showToast(msg: "자리가 있습니다.")
        }
    }
    
    
}
