//
// Created by 이병찬 on 2017. 11. 6..
// Copyright (c) 2017 이병찬. All rights reserved.
//

import Foundation
import UIKit

class ApplyStudyVC: UIViewController  {

    @IBOutlet weak var contentView: BackViewShape!
    
    override func viewDidLoad() {
        contentView.backgroundColor = Color.CO6.getColor()
    }
    
    @IBAction func timeChange(_ sender: UISegmentedControl) {
        
    }
    
}
