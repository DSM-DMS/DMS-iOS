//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxAlamofire

class ApplyStudyVC: UIViewController  {

    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var changeRoomButton: UIButton!
    
    private let roomNameDic = ["가온실" : 1, "나온실" : 2, "다온실" : 3, "라온실" : 4, "3층 독서실" : 5, "4층 독서실" : 6, "열린교실" : 7, "여자 자습실" : 8]
    
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
        if selectedSeat == 0{ showToast(msg: "자리를 선택하세요"); return }
        _ = Connector.instance
            .getRequest(ApplyAPI.applyOrCancelExtensionInfo(time: selectedTime), method: .post,
                        params: ["classNum" : selectedClass, "seatNum" : selectedSeat])
            .emptyData(vc: self)
            .subscribe(onNext: { [weak self] code in
                guard let strongSelf = self else { return }
                switch code{
                case 201: strongSelf.getMap(); strongSelf.showToast(msg: "신청 성공")
                case 204: strongSelf.showToast(msg: "신청 시간이 아닙니다")
                default: strongSelf.showError(code)
                }
            })
    }
    
    @IBAction func cancel(_ sender: ButtonShape) {
        _ = Connector.instance
            .getRequest(ApplyAPI.applyOrCancelExtensionInfo(time: selectedTime), method: .delete)
            .emptyData(vc: self)
            .subscribe(onNext: { [weak self] code in
                guard let strongSelf = self else { return }
                if code == 200{ strongSelf.getMap(); strongSelf.showToast(msg: "취소 성공") }
                else if code == 204{ strongSelf.showToast(msg: "취소 시간이 아닙니다.") }
                else{ strongSelf.showError(code) }
            })
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        selectedTime = sender.selectedSegmentIndex == 0 ? 11 : 12
        getMap()
    }
    
}

extension ApplyStudyVC{
    
    @objc func changeRoom(_ button: UIButton){
        let alert = UIAlertController(title: "방을 선택하세요.", message: nil, preferredStyle: .actionSheet)
        ApplyModel.roomNameArr.forEach{
            alert.addAction(UIAlertAction(title: $0, style: .default, handler: alertClick(_:)))
        }
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func alertClick(_ action: UIAlertAction){
        let title = action.title!
        changeRoomButton.setTitle(title, for: .normal)
        for i in ApplyModel.roomNameArr.indices{
            if ApplyModel.roomNameArr[i] == title{ selectedClass = i + 1 }
        }
        getMap()
    }
    
    private func getMap(){
        selectedSeat = 0
        self.bindData([[1,2,3,4,5,6,7,8,9],[0,0,0,1,2,3,0,0,1], ["1", "2"]])
//        _ = Connector.instance
//            .getRequest(ApplyAPI.getExtensionMapInfo(time: selectedTime), method: .get, params: ["classNum" : "\(selectedClass)"])
//            .getDataForMap(vc: self)
//            .subscribe(onNext: { [weak self] code, data in
//                guard let strongSelf = self else { return }
//                if code == 200{ strongSelf.bindData(data! as! [[Any]]) }
//                else{ strongSelf.showError(code) }
//            })
    }
    
    private func bindData(_ dataArr: [[Any]]){
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
                    if titleInt > 0{ getButton(x: x, y: y, title: "\(titleInt)").setShape(state: .empty) }
                }else{ getButton(x: x, y: y, title: seat as! String).setShape(state: .exist) }
                x += 65
            }
            x = 0
            y += 65
        }
        backScrollView.contentSize = CGSize.init(width: width + 10, height: height + 10)
        backScrollView.addSubview(contentView!)
    }
    
    private func getButton(x: Int, y: Int, title: String) -> UIButton{
        let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: 55, height: 55))
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 55 / 2
        beforeButton?.layer.borderWidth = 2
        contentView?.addSubview(button)
        return button
    }
    
    @objc func onClick(_ button: UIButton){
        if let seatNum = Int(button.title(for: .normal)!){
            beforeButton?.setShape(state: .empty)
            button.setShape(state: .select)
            selectedSeat = seatNum
            beforeButton = button
        }else{
            showToast(msg: "자리가 있습니다")
        }
    }
    
}

extension UIButton{
    
    fileprivate func setShape(state: SeatState){
        switch state {
        case .empty:
            backgroundColor = UIColor.lightGray
            layer.borderWidth = 0
        case .select:
            layer.borderWidth = 4
            layer.borderColor = UIColor.yellow.cgColor
            backgroundColor = UIColor.lightGray
        case .exist:
            backgroundColor = Color.MINT.getColor()
        }
    }
    
}

fileprivate enum SeatState{
    case empty, select, exist
}
