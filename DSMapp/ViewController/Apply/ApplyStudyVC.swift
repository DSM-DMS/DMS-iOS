//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ApplyStudyVC: UIViewController  {

    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var changeRoomButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let roomNameArr = ["가온실", "나온실", "다온실", "라온실", "3층 독서실", "4층 독서실", "열린교실"]
    
    private var selectedTime = 11
    private var selectedClass = 1
    private var selectedSeat = 0
    
    var beforeButton: UIButton? = nil
    var contentView: UIView? = nil
    
    override func viewDidLoad() {
        backScrollView.backgroundColor = Color.CO6.getColor()
        backScrollView.layer.cornerRadius = 8
        changeRoomButton.addTarget(self, action:
            #selector(changeRoom(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMap()
    }
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func apply(_ sender: Any) {
        if selectedSeat == 0{ showToast(msg: "자리를 선택하세요") }
        Connector.instance.request(createRequest(sub: "/extension/\(selectedTime)", method: .post, params: ["class_num" : "\(selectedClass)", "seat_num" : "\(selectedSeat)"]), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                switch code{
                case 201: self.getMap(); self.showToast(msg: "신청 성공")
                case 204: self.showToast(msg: "신청 시간이 아닙니다")
                default: self.showError(code)
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func cancel(_ sender: ButtonShape) {
        Connector.instance.request(createRequest(sub: "/extension/\(selectedTime)", method: .delete, params: [:]), vc: self)
            .subscribe(onNext: { [unowned self] code, _ in
                if code == 200{
                    self.getMap()
                    self.showToast(msg: "취소 성공")
                }else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        selectedTime = sender.selectedSegmentIndex == 0 ? 11 : 12
        getMap()
    }
    
}

extension ApplyStudyVC{
    
    @objc func changeRoom(_ button: UIButton){
        let alert = UIAlertController(title: "방을 선택하세요.", message: nil, preferredStyle: .actionSheet)
        for i in roomNameArr{
            alert.addAction(UIAlertAction(title: i, style: .default, handler: alertClick(_:)))
        }
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
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
        Connector.instance.request(createRequest(sub: "/extension/map/\(selectedTime)", method: .get, params: ["class_num" : "\(selectedClass)"]), vc: self)
            .subscribe(onNext: { [unowned self] code, data in
                if code == 200{
                    let data = try! JSONSerialization.jsonObject(with: data, options: []) as! [[Any]]
                    self.bindData(data)
                }else{ self.showError(code) }
            }).disposed(by: disposeBag)
    }
    
    func bindData(_ dataArr: [[Any]]){
        let width = dataArr[0].count * 65
        let height = dataArr.count * 65
        contentView?.removeFromSuperview()
        let tempX = backScrollView.frame.width - CGFloat(width)
        let tempY = backScrollView.frame.height - CGFloat(height)
        let setX = tempX > 0 ? tempX / 2 : 10
        let setY = tempY > 0 ? tempY / 2 : 10
        contentView = UIView(frame: CGRect.init(x: setX, y: setY, width: CGFloat(width), height: CGFloat(height)))
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
