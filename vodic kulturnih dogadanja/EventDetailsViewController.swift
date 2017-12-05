//
//  EventDetailsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 05/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var eventDetailName: UILabel!
    @IBOutlet weak var eventDetailDescription: UILabel!
    @IBOutlet weak var eventDetailBegin: UILabel!
    @IBOutlet weak var eventDetailEnd: UILabel!
    @IBOutlet weak var eventDetailPrice: UILabel!
    @IBOutlet weak var eventDetailLink: UIButton!
    
    
    var eventImage : UIImage? = nil
    var eventName = ""
    var eventDescription = ""
    var eventBegin = ""
    var eventEnd = ""
    var eventPrice = ""
    var eventLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventDetailImage.image = eventImage
        eventDetailName.text = eventName
        eventDetailDescription.text = eventDescription
        eventDetailBegin.text = formatDate(eventBegin)
        eventDetailEnd.text = formatDate(eventEnd)
        eventDetailPrice.text = eventPrice + " kn"
        eventDetailLink.setTitle(eventLink, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func linkButtonClicked(_ sender: UIButton) {
        let url = URL(string: eventLink)
        UIApplication.shared.open(url!)
    }
    
    func dateFromMilliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func formatDate(_ someDate: String) -> String {
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datum = dateFromMilliseconds(date: dateInInt!)
            
        let konacniDatum = dateFormatter.string(from: datum)
        
        return konacniDatum
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
