//
//  UnregisteredEventDetailsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 09/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class UnregisteredEventDetailsViewController: UIViewController {

    @IBOutlet weak var unregisteredEventImage: UIImageView!
    
    @IBOutlet weak var unregisteredEventName: UILabel!
    @IBOutlet weak var unregisteredEventDescription: UILabel!
    @IBOutlet weak var unregisteredEventBegin: UILabel!
    @IBOutlet weak var unregisteredEventPrice: UILabel!
    @IBOutlet weak var unregisteredEventLink: UIButton!
    
    var eventImage : UIImage? = nil
    var eventName = ""
    var eventDescription = ""
    var eventBegin = ""
    var eventEnd = ""
    var eventPrice = ""
    var eventLink = ""
    
    @IBAction func unregisteredLinkClicked(_ sender: UIButton) {
        let url = URL(string: eventLink)
        UIApplication.shared.open(url!)
    }
    
    func dateFromMilliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func formatDate(_ someDate: String) -> String {
        
        if someDate == "" {
            return ""
        }
        
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFromMilliseconds(date: dateInInt!)
        
        let finalDate = dateFormatter.string(from: date)
        
        return finalDate
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        unregisteredEventImage.image = eventImage
        unregisteredEventName.text = eventName
        unregisteredEventDescription.text = eventDescription
        
        if formatDate(eventEnd) == "" {
            unregisteredEventBegin.text = formatDate(eventBegin)
        }
        else {
            unregisteredEventBegin.text = formatDate(eventBegin) + "-" + formatDate(eventEnd)
        }
        
        unregisteredEventPrice.text = eventPrice + " kn"
        unregisteredEventLink.setTitle(eventLink, for: .normal)
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
