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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        if let kojiDatum = NumberFormatter().number(from: (dict["begin"] as? String)!)?.intValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datum = dateFromMilliseconds(date: kojiDatum)
            
            let konacniDatum = dateFormatter.string(from: datum)
            cell?.beginLabel.text = konacniDatum
            
        }
        
        /*
        let dateFormatter = DateFormatter()
        cell?.beginLabel.text = dateFormatter.string(from: dateFromMilliseconds(date: (NumberFormatter().number(from: (dict["begin"] as? String)!)?.intValue)!))*/
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                
                unregisteredDetailsViewController.eventName = event["name"] as! String
                unregisteredDetailsViewController.eventDescription = event["description"] as! String
                unregisteredDetailsViewController.eventBegin = event["begin"] as! String
                unregisteredDetailsViewController.eventEnd = event["end"] as! String
                unregisteredDetailsViewController.eventPrice = event["price"] as! String
                unregisteredDetailsViewController.eventLink = event["link"] as! String
                
            }
        }
    }

}
