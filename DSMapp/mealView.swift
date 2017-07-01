//
//  mealView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 16..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class mealView: UIViewController {
    
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
        
        firtstDataSet()
        //dbset
        
        
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
            i.layer.shadowOpacity = 1
            i.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            i.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        }
        //그림자 세팅
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(mealView.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(mealView.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        //제스쳐 세팅
        
    }

    func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
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
                break
            }
        }
    }
    
    
    func firtstDataSet(){
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        let databasePath = docsDir + "/dsmappdatabase.db"
        
        if !filemgr.fileExists(atPath: databasePath){
            ap.db = FMDatabase.init(path: databasePath)
            
            if ap.db == nil{
                return
            }
            
            if ap.db?.open() != nil{
                var sql_statement = "CREATE TABLE if not exists meal(date text, blackfast text, lunch text, dinner text)"
                ap.db?.executeStatements(sql_statement)
                sql_statement = "CREATE TABLE if not exists login(key text, id text, password text)"
                ap.db?.executeStatements(sql_statement)
                let sql_query = "insert into login values('user','','')"
                ap.db?.executeUpdate(sql_query, withArgumentsIn: nil)
            }
            
            if !(ap.db?.hadError())!{
                for i in 0..<30{
                    tempDataInsert(i)
                }
            }
            
           
            firstCheck = true
        }else{
            ap.db = FMDatabase.init(path: databasePath)
            func autoLogin() -> Bool{
                if self.ap.db?.open() != nil{
                    let sql_query = "select * from login"
                    let result = self.ap.db?.executeQuery(sql_query, withArgumentsIn: nil)
                    
                    if result != nil{
                        while (result?.next())! {
                            return self.ap.login(id: (result?.string(forColumn: "id"))!, pw: (result?.string(forColumn: "password"))!)
                        }
                    }
                }
                return false
            }
            
            check = autoLogin()
            
            var sql_query = "DELETE FROM meal where date = \"\((getDateData(date: Date() - TimeInterval(86400)))[4])\""
            if ap.db?.open() != nil{
                ap.db?.executeUpdate(sql_query, withArgumentsIn: nil)
                if !((ap.db?.hadError())!){
                    sql_query = "select * from meal where date = \"\(getDateData(date: Date() + TimeInterval(86400 * 29))[4])\""
                    let result = ap.db?.executeQuery(sql_query, withArgumentsIn: nil)
                    if result != nil{
                        if !(result?.next())!{
                            tempDataInsert(29)
                        }
                    }
                }
            }
        }

    }
    
    func tempDataInsert(_ num : Int , date : Date = Date()){
        let dateData = getDateData(date: date + TimeInterval(86400 * num))
        ap.getAPI(add: "/school/meal", param: "year=\(dateData[0])&month=\(dateData[3])&day=\(dateData[2])", method: "GET", fun: {
            data, res, err in
            if(err == nil){
                if res?.statusCode == 200{
                    self.ap.db?.open()
                    let tempSaveData = self.changeDataForSave(data: data)
                    let sql_query = "INSERT into meal values (\"\(dateData[4])\",\"\(tempSaveData[0])\",\"\(tempSaveData[1])\",\"\(tempSaveData[2])\")"
                    
                    self.ap.db?.executeUpdate(sql_query, withArgumentsIn: nil)
                    
                }
            }
        })
    }
    
    func changeDataForSave(data : Any?) -> [String]{
        let temp = (data as! Dictionary<String, Any>)["Meals"] as! Array<Dictionary<String,Array<String>>>
        var tempArray = [String]()
        for i in temp{
            var text = ""
            for var j in i["Menu"]!{
                if j.contains("amp;"){
                    j.remove(at: j.characters.index(of: "a")!)
                    j.remove(at: j.characters.index(of: "m")!)
                    j.remove(at: j.characters.index(of: "p")!)
                    j.remove(at: j.characters.index(of: ";")!)
                }
                text += j + " "
            }
            tempArray.append(text)
        }
        
        return tempArray
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
    
    var firstCheck = false
    var check = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: TimeInterval(0.5), animations: setFirst, completion: {
            bool in
            if !self.firstCheck{
                if self.check{
                    self.showToast(message: "자동 로그인 성공!")
                }else{
                    self.showToast(message: "로그인이 필요합니다.")
                }
            }
            self.firstCheck = true
        })
        //애니매이션
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
        
        if (ap.db?.open() != nil){
            let sql_query = "SELECT * from meal where date=\"\((getDateData(date: date))[4])\""
            let result = ap.db?.executeQuery(sql_query, withArgumentsIn: nil)
            if result != nil{
                while (result?.next())!{
                    setDataTextView((result?.string(forColumn: "blackfast"))!, textView: dataArray[0])
                    setDataTextView((result?.string(forColumn: "lunch"))!, textView: dataArray[1])
                    setDataTextView((result?.string(forColumn: "dinner"))!, textView: dataArray[2])
                    return
                }
            }
        }
        
        if (getDateData(date: date)[4] != getDateData(date: Date() - TimeInterval(86400))[4]) && (getDateData(date: date)[4] != getDateData(date: Date() + TimeInterval(86400 * 29))[4]){
            tempDataInsert(0, date: date)
        }
        
        setDataTextView("데이터를 로딩 중 입니다.", textView: dataArray[0])
        setDataTextView("이러힌 오류가 지속된다면\n먼저 네트워크 상태를 확인해 주시고", textView: dataArray[1])
        setDataTextView("DSMDMS 관계자에게 문의해주십시오.", textView: dataArray[2])
    }
    
    func setDataToView(){
        self.setDateData(self.stanDate + TimeInterval(86400), timeArray: self.nextDate, dataArray: self.nextTextView)
        self.setDateData(self.stanDate, timeArray: self.curruntDate, dataArray: self.curruntTextView)
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

                
                i.center.x = self.viewArray[count+1].center.x
                i.alpha = self.viewArray[count+1].alpha
                
                if(count == 1){
                    i.backgroundColor = UIColor.white
                    i.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                    
                }else{
                    i.backgroundColor = UIColor.lightGray
                    i.transform = CGAffineTransform.init(a: 0.8, b: 0, c: 0, d: 0.8, tx: 0, ty: 0)
                }
                count = count + 1
            }
            
        }, completion: {
            bool in
            self.setDataToView()
            self.setFirst()
        })
        
        if(right){
            viewArray.reverse()
            viewConstraint.reverse()
        }
    }
    
}
