//
//  UnregisteredViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 02/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

///Class for showing events for unregistered user
class UnregisteredViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfEvents = [[String:AnyObject]]()
    
    func currentDateInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    ///Getting events from server and showing in table view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("titleAllEvents", comment: "")
        
        let dateInMiliseconds = currentDateInMiliseconds()
        let URL = "http://vodickulturnihdogadanja.1e29g6m.xip.io/eventList.php"
        
        let param = ["begin": dateInMiliseconds, "keyword": ""] as [String : Any]
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfEvents.count
    }
    
    func dateFromMilliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as? UnregisteredEventTableViewCell
        var dict = arrayOfEvents[indexPath.row]
        
        let imageString = dict["picture"] as? String
        if let imageData = Data(base64Encoded: imageString!) {
            let decodedImage = UIImage(data: imageData)
            cell?.unregisteredImageView.image = decodedImage
        }
        
        cell?.nameLabel.text = dict["name"] as? String
        cell?.descriptionLabel.text = dict["description"] as? String
        
        
        let begin = formatDate(dict["begin"] as! String)
        let end = formatDate(dict["end"] as! String)
        
        if end == "0" {
            cell?.beginLabel.text = begin + "h"
        }
        else {
            cell?.beginLabel.text = begin + "h  -  " + end + "h"
        }
        
        return cell!
    }
    
    func formatDate(_ someDate: String) -> String {
        
        if someDate == "" {
            return ""
        }
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY. HH:mm"
        let date = dateFromMilliseconds(date: dateInInt!)
        
        let finalDate = dateFormatter.string(from: date)
        
        return finalDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///Preparing segue for forwarding event id
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let unregisteredDetailsViewController = segue.destination as! UnregisteredEventDetailsViewController
        
        if segue.identifier == "unregisteredEventDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let event = arrayOfEvents[indexPath.row]
                
                let imageString = event["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    unregisteredDetailsViewController.eventImage = decodedImage
                }
                
                if (event["end"] as! String)  == "0" {
                    unregisteredDetailsViewController.eventEnd = ""
                }
                else {
                    unregisteredDetailsViewController.eventEnd = event["end"] as! String
                }
                
                unregisteredDetailsViewController.eventName = event["name"] as! String
                unregisteredDetailsViewController.eventDescription = event["description"] as! String
                unregisteredDetailsViewController.eventBegin = event["begin"] as! String
                unregisteredDetailsViewController.eventPrice = event["price"] as! String
                unregisteredDetailsViewController.eventLink = event["link"] as! String
                
            }
        }
    }

}
