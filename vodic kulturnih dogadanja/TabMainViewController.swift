//
//  TabMainViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 17/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class TabMainViewController: UITabBarController {
    
    static var eventId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        print(TabMainViewController.eventId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
