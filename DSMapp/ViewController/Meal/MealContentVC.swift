//
//  MealContentVC.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 11. 6..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RxSwift

class MealContentVC: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var blackTextView: UITextView!
    @IBOutlet weak var lunchTextView: UITextView!
    @IBOutlet weak var dinnerTextView: UITextView!
    
    var date: Date!
    let formatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        setDateStr()
        getData()
    }

    func getData(){
        _ = Connector.instance
                .getRequest(InfoAPI.getMealInfo(date: getDateStr()), method: .get)
                .decodeData(MealModel.self, vc: self)
                .subscribe(onNext: { [weak self] code, data in
                    switch code{
                    case 200: self?.setData(data!.getData())
                    case 204: self?.setData(("급식이 없습니다.", "급식이 없습니다.", "급식이 없습니다."))
                    default: self?.showError(code)
                    }
                })
    }

}

extension MealContentVC{
    
    private func setDateStr(){
        formatter.dateFormat = "YYYY/M월 d일/EEEE"
        let dateStrArr = formatter.string(from: date).split(separator: "/")
        yearLabel.text = dateStrArr[0].description
        weekLabel.text = dateStrArr[1].description
        dayLabel.text = dateStrArr[2].description
    }
    
    private func getDateStr() -> String{
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: date)
    }
    
    private func setData(_ data: MealTuple){
        blackTextView.text = data.breakfast
        lunchTextView.text = data.lunch
        dinnerTextView.text = data.dinner
    }
    
}
