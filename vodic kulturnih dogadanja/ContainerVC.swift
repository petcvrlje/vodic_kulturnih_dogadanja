//
//  ViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 23/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {

    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    var sideMenuOpen = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("toggleSideMenu"),
                                               object: nil)
    }

    
    @objc func toggleSideMenu(){
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = -240
            
                      
        }else{
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
            
  
        }

    }
    
}

