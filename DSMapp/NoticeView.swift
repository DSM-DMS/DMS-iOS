//
//  noticeView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 22..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class NoticeView: UIViewController, UITextViewDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    var buttonArr = [UIButton]()
    
    let ap = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        var temp = view.frame.height
        if temp < 667{
            temp = 1
        }else if temp == 667{
            temp = 1.1
        }else{
            temp = 1.2
        }
        
        stackView.transform = CGAffineTransform.init(a: temp, b: 0, c: 0, d: temp, tx: 0, ty: 0)
        view.backgroundColor = UIColor.init(red: 219/255, green: 234/255, blue: 242/255, alpha: 1)
        
        for i in [view1,view2,view3,view4]{
            i?.backgroundColor = UIColor.white
            i?.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            i?.layer.shadowOffset = CGSize.init(width: 1, height: 1)
            i?.layer.shadowOpacity = 0.3
            
            i?.layer.cornerRadius = 10
        }
        
        buttonArr = [button1,button2,button3,button4]
        
        for i in buttonArr{
            i.addTarget(self, action: #selector(nextListView(_:)), for: .touchUpInside)
            i.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            i.layer.shadowOffset = CGSize.init(width: 1, height: 1)
            i.layer.shadowOpacity = 0.3
        }
        

        
    }
    
    func setFacilityView(){
        contentView = self.storyboard?.instantiateViewController(withIdentifier: "facilityViewController") as! FacilityView
        contentView.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        contentView.contentTextView.delegate = self
        contentView.sendButton.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
        contentView.backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.view.addSubview(contentView.view)
    }
    
    var contentView = FacilityView()
    
    func send(_ button : UIButton){
        back(button);
    }
    
    func back(_ button : UIButton){
        contentView.view.removeFromSuperview()
    }
    
    func nextListView(_ button : UIButton){
        let noticeTitleArr = ["기숙사 규정","공지사항","자주하는 질문","시설 고장 신고"]
        for i in 0..<buttonArr.count{
            if button == buttonArr[i]{
                ap.noticeTitle = noticeTitleArr[i];
                if i == 3{
                    setFacilityView()
                    return
                }
                present((self.storyboard?.instantiateViewController(withIdentifier: "noticeListView"))!, animated: true, completion: nil)
                return
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "정보를 입력하십시오"{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "정보를 입력하십시오"
        }
    }

}
