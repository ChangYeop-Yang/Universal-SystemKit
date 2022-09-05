//
//  ViewController.swift
//  SystemKitTesting
//
//  Created by ChangYeop-Yang on 2022/08/21.
//

import UIKit
import SystemKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SKSystem.shared.getApplicationVersion()
    }


}

