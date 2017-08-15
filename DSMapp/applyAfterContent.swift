//
//  applyAfterContent.swift
//  DSMapp
//
//  Created by 이병찬 on 2017. 8. 15..
//  Copyright © 2017년 이병찬. All rights reserved.
//

import UIKit

class applyAfterContent: UIViewController {
    
    var contentIndex = 0

    let colorArray = [UIColor.red,UIColor.black,UIColor.blue,UIColor.brown]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeBack(){
        view.backgroundColor = colorArray[contentIndex]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
