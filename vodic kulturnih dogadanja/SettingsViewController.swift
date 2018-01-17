//
//  SettingsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 16/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    

    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("menuSettings", comment: "")
        notificationsLabel.text = NSLocalizedString("notifications", comment: "")
        languageLabel.text = NSLocalizedString("language", comment: "")
        
        if (!UIApplication.shared.isRegisteredForRemoteNotifications) {
            notificationsSwitch.setOn(true, animated: true)
        }
        else {
            notificationsSwitch.setOn(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notificationsSwitched(_ sender: UISwitch) {
        if (notificationsSwitch.isOn && !notificationsSwitch.isSelected) {
            notificationsSwitch.isSelected = true
            
            enablePushNotifications()
        }
        else if (!notificationsSwitch.isOn) {
            notificationsSwitch.isSelected = false
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func enablePushNotifications() {
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            })
        }
        else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        switch  languageSegment.selectedSegmentIndex {
        case 0:
            print("Croatian.")
        case 1:
            print("English.")
        default:
            print("Default.")
        }
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
