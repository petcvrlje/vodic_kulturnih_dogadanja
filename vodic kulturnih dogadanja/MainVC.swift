//
//  MainVC.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfEvents = [[String:AnyObject]]()
    
    func currentDateInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970*1000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateInMiliseconds = currentDateInMiliseconds()
        let URL = "http://vodickulturnihdogadanja.1e29g6m.xip.io/eventList.php"
        
        let param = ["begin": dateInMiliseconds, "keyword": ""] as [String:Any]
        
        Alamofire.request(URL, parameters: param).responseJSON {
            response in
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayOfEvents = resData as! [[String:AnyObject]]
                }
                if self.arrayOfEvents.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func dateFromMiliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainEventsCell")! as? RegisteredEventTableViewCell
        var dict = arrayOfEvents[indexPath.row]
        
    
        let imageString = dict["picture"] as? String
        if let imageData = Data(base64Encoded: imageString!) {
            let decodedImage = UIImage(data: imageData)
            cell?.eventImageView.image = decodedImage
        }
        
        cell?.nameLabel.text = dict["name"] as? String
        cell?.descriptionLabel.text = dict["description"] as? String
        
        if let kojiDatum = NumberFormatter().number(from: (dict["begin"] as? String)!)?.intValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datum = dateFromMiliseconds(date: kojiDatum)
            
            let konacniDatum = dateFormatter.string(from: datum)
            cell?.beginLabel.text = konacniDatum
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventDetailsViewController = segue.destination as! EventDetailsViewController
        
        if segue.identifier == "eventDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let event = arrayOfEvents[indexPath.row]
                eventDetailsViewController.eventImage = event["photo"] as? UIImage
                eventDetailsViewController.eventName = event["name"] as! String
                eventDetailsViewController.eventDescription = event["description"] as! String
                eventDetailsViewController.eventBegin = event["begin"] as! String
                eventDetailsViewController.eventEnd = event["end"] as! String
                eventDetailsViewController.eventPrice = event["price"] as! String
                eventDetailsViewController.eventLink = event["link"] as! String
            }
        }
    }
}
