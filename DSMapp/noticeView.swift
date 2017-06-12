//
//  noticeView.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 5. 22..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class noticeView: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
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
        
        for i in [button1,button2,button3,button4]{
            i?.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            i?.layer.shadowOffset = CGSize.init(width: 1, height: 1)
            i?.layer.shadowOpacity = 0.3
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
