//
//  StartScreen.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Localize_Swift

///Class for starting screen
class StartScreenVC: UIViewController {
    
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var continueWithoutLoginLabel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loginLabel.setTitle("login".localized(), for: .normal)
        continueWithoutLoginLabel.setTitle("continueWithoutLogin".localized(), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
