//
//  mealView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit
import RealmSwift

class MealView: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var beforeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var blackFastLabel: UITextView!
    @IBOutlet weak var lunchLabel: UITextView!
    @IBOutlet weak var dinnerLabel: UITextView!
    //메인뷰
    //---------------------
    
    @IBOutlet weak var nextYearLabel: UILabel!
    @IBOutlet weak var nextDayLabel: UILabel!
    @IBOutlet weak var nextMonthLabel: UILabel!
    @IBOutlet weak var nextBlackFastLabel: UITextView!
    @IBOutlet weak var nextLunchLabel: UITextView!
    @IBOutlet weak var nextDinnerLabel: UITextView!
    //next뷰
    //---------------------
    
    @IBOutlet weak var beforeDayLabel: UILabel!
    @IBOutlet weak var beforeMonthLabel: UILabel!
    @IBOutlet weak var beforeYearLabel: UILabel!
    @IBOutlet weak var beforeBlackFastLabel: UITextView!
    @IBOutlet weak var beforeLunchLabel: UITextView!
    @IBOutlet weak var beforeDinnerLabel: UITextView!
    //before뷰
    //---------------------
    
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    var viewArray = Array<UIView>()
    
    var stanDate = Date()
    
    
    var beforeDate = Array<UILabel>()
    var curruntDate = Array<UILabel>()
    var nextDate = Array<UILabel>()
    var beforeTextView = Array<UITextView>()
    var curruntTextView = Array<UITextView>()
    var nextTextView = Array<UITextView>()
    
    
    var fomatter = DateFormatter()
    
    override func viewDidLoad() {
        beforeDate = [beforeYearLabel,beforeMonthLabel,beforeDayLabel]
        beforeTextView = [beforeBlackFastLabel,beforeLunchLabel,beforeDinnerLabel]
        curruntDate = [yearLabel,monthLabel,dayLabel]
        curruntTextView = [blackFastLabel,lunchLabel,dinnerLabel]
        nextDate = [nextYearLabel,nextMonthLabel,nextDayLabel]
        nextTextView = [nextBlackFastLabel,nextLunchLabel,nextDinnerLabel]
        
        viewArray = [view1,view2,view3,view4,view5]
        
        viewConstraint = [self.view1Constraint,self.view2Constraint,self.view3Constraint,self.view4Constraint,self.view5Constraint]
        
        
        fomatter.timeZone = NSTimeZone.default
        
        for i in curruntTextView{
            i.isEditable = false
            i.isSelectable = false
        }
        
        beforeButton.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        beforeButton.layer.shadowOpacity = 1
        beforeButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        nextButton.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        for i in viewArray{
            i.layer.cornerRadius = 13
            i.layer.borderWidth = 0.3
            i.layer.shadowOffset = CGSize.init(width: 1, height: 1)
            i.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            i.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        }
        //그림자 세팅
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(MealView.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(MealView.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        //제스쳐 세팅
        
    }

    override func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizerDirection.right :
                if (getDateData(date: stanDate) == getDateData(date: Date())){
                    return
                }
                move()

            case UISwipeGestureRecognizerDirection.left :
                if (getDateData(date: stanDate) == getDateData(date: (Date() + TimeInterval(86400 * 29)))){
                    return
                }
                move(true)
            default:
                return
            }
        }
    }
    
    
    func changeDataForSave(data : Any?) -> [String : String]{
        
        func tempStrToArr(changeData : Data) -> Array<String>?{
            do{
                let useTemp = try JSONSerialization.jsonObject(with: changeData, options: [])
                return useTemp as? Array<String>
            }catch{
                return nil
            }
        }
        
        let temp = data as! Dictionary<String, String>
        
        var sendDic = ["breakfast":String(),"lunch":String(),"dinner":String()]
        for i in temp{
            if let j = tempStrToArr(changeData: (i.value).data(using: .utf8)!){
                var tempStr = String()
                for var k in j{
                    if k.contains("amp;"){
                        k.remove(at: k.characters.index(of: "a")!)
                        k.remove(at: k.characters.index(of: "m")!)
                        k.remove(at: k.characters.index(of: "p")!)
                        k.remove(at: k.characters.index(of: ";")!)
                    }
                    
                    tempStr += (k + " ")
                }
                sendDic[i.key] = tempStr
            }
        }
        
        return sendDic
    }
    
    
    
    @IBOutlet weak var view3Constraint: NSLayoutConstraint!
    @IBOutlet weak var view5Constraint: NSLayoutConstraint!
    @IBOutlet weak var view2Constraint: NSLayoutConstraint!
    @IBOutlet weak var view4Constraint: NSLayoutConstraint!
    @IBOutlet weak var view1Constraint: NSLayoutConstraint!
    
    
    var viewConstraint = [NSLayoutConstraint]()
    
    override func viewWillAppear(_ animated: Bool) {
        stanDate = Date()
        for i in viewConstraint{
            i.constant = 0
        }
        
        for i in viewArray{
            i.backgroundColor = UIColor.white
            i.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            i.alpha = 1
        }
        setDataToView()
        //초기세팅
    }
    
    var first = true
    
    func autoLogin(_ msgShow : Bool = true){
        let realm = try! Realm()
        let userData = realm.objects(LoginData.self).first
        if userData == nil{
            showToast(message: "로그인이 필요합니다.")
        }else{
            ap.login(id: userData!.id, pw: userData!.password, save: true, viewCon: self, msgShow: msgShow)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: TimeInterval(0.5), animations: setFirst, completion: {
            bool in
            if self.first{
                self.autoLogin()
            }
            self.first = false
        })
    }
    
    @IBAction func before(_ sender: Any) {
        if (getDateData(date: stanDate) == getDateData(date: Date())){
            return
        }
        move()
    }
    
    @IBAction func after(_ sender: Any) {
        if (getDateData(date: stanDate) == getDateData(date: (Date() + TimeInterval(86400 * 29)))){
            return
        }
        move(true)
    }
    
    @IBOutlet weak var button: UIStackView!
    
    func setFirst(){
        for i in 0..<self.viewArray.count{
            if(i == 2){
                self.view.bringSubview(toFront: self.viewArray[i])
                self.view.bringSubview(toFront: self.button)
                self.viewArray[i].backgroundColor = UIColor.white
                self.viewArray[i].transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                self.viewArray[i].alpha = 1
                continue
            }else{
                self.viewArray[i].backgroundColor = UIColor.lightGray
                self.viewArray[i].transform = CGAffineTransform.init(a: 0.8, b: 0, c: 0, d: 0.8, tx: 0, ty: 0)
                
                self.viewArray[i].alpha = 0.5
            }
        }
        
        self.view1Constraint.constant = -500
        self.view2Constraint.constant = -280
        self.view3Constraint.constant = 0
        self.view4Constraint.constant = 280
        self.view5Constraint.constant = 500
    }
    
    //애니메이션 삽입 함수
    
    
    func getDateData(date: Date) -> [String]{
        func setFormmate(_ format : String) -> String{
            fomatter.dateFormat = format
            return fomatter.string(from: date)
        }
        
        var sendDateArray = [setFormmate("yyyy")]
        sendDateArray.append(setFormmate("MMMM"))
        sendDateArray.append(setFormmate("dd"))
        sendDateArray.append(setFormmate("MM"))
        sendDateArray.append(setFormmate("yyyy-MM-dd"))
        
        return sendDateArray
    }
    
    func setDateData(_ date: Date,timeArray : [UILabel],dataArray : [UITextView]){
        func setDataTime(_ str: String, label: UILabel){
            label.text = str
        }
        
        func setDataTextView(_ str: String, textView: UITextView){
            textView.text = str
        }
        
        for i in 0..<timeArray.count{
            timeArray[i].text = (getDateData(date: date))[i]
        }
        
        ap.getAPI(add: "meal", param: "year=\(getDateData(date: date)[0])&month=\(getDateData(date: date)[3])&day=\(getDateData(date: date)[2])", method: "GET", fun: {
            data, res, err in
            if(err == nil){
                if res?.statusCode == 200{
                    let tempSaveData = self.changeDataForSave(data: data)
                    DispatchQueue.main.async {
                        setDataTextView(tempSaveData["breakfast"]!, textView: dataArray[0])
                        setDataTextView(tempSaveData["lunch"]!, textView: dataArray[1])
                        setDataTextView(tempSaveData["dinner"]!, textView: dataArray[2])
                    }
                }
                self.autoLogin(false)
            }else{
                DispatchQueue.main.async {
                    setDataTextView("데이터를 불러오지 못했습니다.", textView: dataArray[0])
                    setDataTextView("모바일 네트워크를 확인해주세요", textView: dataArray[1])
                    setDataTextView("DSM DMS - iOS", textView: dataArray[2])
                }
            }
        })
        
        if(dataArray[0].text.isEmpty){
            setDataTextView("데이터를 로딩 중 입니다.", textView: dataArray[0])
            setDataTextView("잠시만 기다려 주세요.", textView: dataArray[1])
            setDataTextView("DSM DMS - iOS", textView: dataArray[2])
        }
    }
    
    func setDataToView(_ first : Bool = true, right : Bool = false){
        if first{
            self.setDateData(self.stanDate, timeArray: self.curruntDate, dataArray: self.curruntTextView)
        }else{
            for i in 0..<self.curruntDate.count{
                if right{
                    self.curruntDate[i].text = self.nextDate[i].text
                }else{
                    self.curruntDate[i].text = self.beforeDate[i].text
                }
            }
            for i in 0..<self.curruntTextView.count{
                if right{
                    self.curruntTextView[i].text = self.nextTextView[i].text
                }else{
                    self.curruntTextView[i].text = self.beforeTextView[i].text
                }
            }
        }
        self.setDateData(self.stanDate + TimeInterval(86400), timeArray: self.nextDate, dataArray: self.nextTextView)
        self.setDateData(self.stanDate - TimeInterval(86400), timeArray: self.beforeDate, dataArray: self.beforeTextView)
    }
    
    func move(_ right :Bool = false){
        if(right){
            viewArray.reverse()
            viewConstraint.reverse()
            stanDate = stanDate + TimeInterval(86400)
            
        }else{
            stanDate = stanDate - TimeInterval(86400)
        }
        
        UIView.animate(withDuration: TimeInterval(0.25), animations: {
            var count = 0
            for i in self.viewArray{
                
                if(count>3){
                    break
                }
                
                self.viewArray[count].center.x = self.viewArray[count + 1].center.x
                self.viewArray[count].alpha = self.viewArray[count + 1].alpha
                
                if(count == 1){
                    i.backgroundColor = UIColor.white
                }else{
                    i.backgroundColor = UIColor.lightGray
                }
                
                count = count + 1
            }
            
        }, completion: {
            bool in
            self.setDataToView(false, right: right)
            self.setFirst()
        })
        
        if(right){
            viewArray.reverse()
            viewConstraint.reverse()
        }
    }
    
}
