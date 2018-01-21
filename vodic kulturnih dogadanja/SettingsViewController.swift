//
//  SettingsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 16/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import Localize_Swift

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var pushUpNotification = ""
    var languageId = ""
    

    @IBAction func onMoreTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menuSettings".localized()
        notificationsLabel.text = "notifications".localized()
        languageLabel.text = "language".localized()
        settingsLook(notification: pushUpNotification, language: languageId)
        
        if (!UIApplication.shared.isRegisteredForRemoteNotifications) {
            notificationsSwitch.setOn(true, animated: true)
            pushUpNotification = "1"
        }
        else {
            notificationsSwitch.setOn(false, animated: true)
            pushUpNotification = "0"
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
            languageId = "2"
            Localize.setCurrentLanguage("hr")
            NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
            updateUI()
            UserDefaults.standard.set("hr", forKey: "LCLCurrentLanguageKey")
            UserDefaults.standard.synchronize()
            languageSegmentLook()
        case 1:
            print("English.")
            languageId = "1"
            Localize.setCurrentLanguage("en")
            NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
            updateUI()
            UserDefaults.standard.set("en", forKey: "LCLCurrentLanguageKey")
            UserDefaults.standard.synchronize()
            languageSegmentLook()
        default:
            print("Default.")
        }
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        let userId = Int(self.defaults.string(forKey: "userId")!)
        let urlSaveSettings = "http://vodickulturnihdogadanja.1e29g6m.xip.io/settings.php"
        
        let params = ["userId" : userId!, "pushUpNotification" : pushUpNotification, "languageId" : languageId] as [String:Any]
        
        Alamofire.request(urlSaveSettings, method: .post, parameters: params, encoding: JSONEncoding.default).responseString {
            response in
            
            let alertController = UIAlertController(title: "settingsChanged".localized(), message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        if languageId == "1" {
            UserDefaults.standard.set("en", forKey: "LCLCurrentLanguageKey")
            UserDefaults.standard.synchronize()
        }
        else if languageId == "2" {
            UserDefaults.standard.set("hr", forKey: "LCLCurrentLanguageKey")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    func getSettings() {
        let userId = Int(self.defaults.string(forKey: "userId")!)
        let param = ["userId" : userId!] as [String:Any]
        
        let url = "http://vodickulturnihdogadanja.1e29g6m.xip.io/settings.php"
        
        Alamofire.request(url, method: .get, parameters: param).responseJSON {
            response in
            if let json = response.result.value as? NSDictionary {
                self.pushUpNotification = json["pushUpNotification"] as! String
                self.languageId = json["languageId"] as! String
        
                if self.languageId == "1" {
                    UserDefaults.standard.set("en", forKey: "LCLCurrentLanguageKey")
                    UserDefaults.standard.synchronize()
                }
                else if self.languageId == "2" {
                    UserDefaults.standard.set("hr", forKey: "LCLCurrentLanguageKey")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    func settingsLook(notification: String, language: String) {
        getSettings()
        
        switch notification {
        case "0": notificationsSwitch.setOn(false, animated: true)
        case "1": notificationsSwitch.setOn(true, animated: true)
        default:
            print("Error")
        }
        
        switch language {
        case "1": languageSegment.selectedSegmentIndex = 1
        case "2": languageSegment.selectedSegmentIndex = 0
        default:
            print("Error")
        }
        
        updateUI()
    }

    @objc func updateUI() {
        navigationItem.title = "menuSettings".localized()
        notificationsLabel.text = "notifications".localized()
        languageLabel.text = "language".localized()
        saveButton.setTitle("save".localized(), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        settingsLook(notification: pushUpNotification, language: languageId)
        languageSegmentLook()
        notificationsSwitchLook()
    }
    
    func languageSegmentLook() {
        if UserDefaults.standard.string(forKey: "LCLCurrentLanguageKey") == "en" {
            languageSegment.selectedSegmentIndex = 1
        }
        else if UserDefaults.standard.string(forKey: "LCLCurrentLanguageKey") == "hr" {
            languageSegment.selectedSegmentIndex = 0
        }
    }
    
    func notificationsSwitchLook() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            notificationsSwitch.setOn(true, animated: true)
        }
        else {
            notificationsSwitch.setOn(false, animated: true)
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
