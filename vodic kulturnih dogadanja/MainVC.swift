//
//  MainVC.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
}
