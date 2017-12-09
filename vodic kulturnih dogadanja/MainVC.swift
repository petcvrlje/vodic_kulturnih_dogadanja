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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var arrayOfEvents = [[String:AnyObject]]()
    var filteredEvents = [[String:AnyObject]]()
    
    var inSearchMode = false
    
    func currentDateInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970*1000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        let dateInMiliseconds = currentDateInMiliseconds()
        let URL = "http://vodickulturnihdogadanja.1e29g6m.xip.io/eventList.php"
        
        let param = ["begin": dateInMiliseconds, "keyword": ""] as [String:Any]
        
        Alamofire.request(URL, parameters: param).responseJSON {
            response in
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                //print(swiftyJsonVar)
                
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
        if inSearchMode {
            return filteredEvents.count
        }
        return arrayOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainEventsCell")! as? RegisteredEventTableViewCell
        
        
        if inSearchMode {
            var filtered = filteredEvents[indexPath.row]
            
            let imageString = filtered["picture"] as? String
            if let imageData = Data(base64Encoded: imageString!) {
                let decodedImage = UIImage(data: imageData)
                cell?.eventImageView.image = decodedImage
            }
            
            cell?.nameLabel.text = filtered["name"] as? String
            cell?.descriptionLabel.text = filtered["description"] as? String
            
            if let whichDate = NumberFormatter().number(from: (filtered["begin"] as? String)!)?.intValue {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFromMiliseconds(date: whichDate)
                
                let finalDate = dateFormatter.string(from: date)
                cell?.beginLabel.text = finalDate
            }
        }
        else {
            var dict = arrayOfEvents[indexPath.row]
            
            let imageString = dict["picture"] as? String
            if let imageData = Data(base64Encoded: imageString!) {
                let decodedImage = UIImage(data: imageData)
                cell?.eventImageView.image = decodedImage
            }
            
            cell?.nameLabel.text = dict["name"] as? String
            cell?.descriptionLabel.text = dict["description"] as? String
            
            
            cell?.beginLabel.text = formatDate((dict["begin"] as? String)!)
        }
        
        return cell!
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
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            inSearchMode = true
            //filteredEvents = arrayOfEvents.filter({$0["name"] as? String == searchBar.text})
            filteredEvents = arrayOfEvents.filter({ (array: [String:AnyObject]) -> Bool in
                if (array["name"]?.contains(searchBar.text!))! {
                    return true
                }
                else {
                    return false
                }
            })
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventDetailsViewController = segue.destination as! EventDetailsViewController
        
        if segue.identifier == "eventDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let event = arrayOfEvents[indexPath.row]
                
                let eventId = event["eventId"] as! String
                eventDetailsViewController.eventId = eventId
                
                let imageString = event["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    eventDetailsViewController.eventImage = decodedImage
                }
                
                if (event["end"] as! String)  == "0" {
                    eventDetailsViewController.eventEnd = ""
                }
                else {
                    eventDetailsViewController.eventEnd = event["end"] as! String
                }
                
                eventDetailsViewController.eventName = event["name"] as! String
                eventDetailsViewController.eventDescription = event["description"] as! String
                eventDetailsViewController.eventBegin = event["begin"] as! String
                
                eventDetailsViewController.eventPrice = event["price"] as! String
                eventDetailsViewController.eventLink = event["link"] as! String
            }
        }
    }
}
