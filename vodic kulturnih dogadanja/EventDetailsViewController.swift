//
//  EventDetailsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 05/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var eventDetailName: UILabel!
    @IBOutlet weak var eventDetailDescription: UILabel!
    @IBOutlet weak var eventDetailBegin: UILabel!
    @IBOutlet weak var eventDetailPrice: UILabel!
    @IBOutlet weak var eventDetailLink: UIButton!
    
    
    var eventImage: UIImage?
    var eventName = ""
    var eventDescription = ""
    var eventBegin = ""
    var eventEnd = ""
    var eventPrice = ""
    var eventLink = ""
    
    
    var eventId = ""
    
    let defaults = UserDefaults.standard
    
    var paramEventId = 0
    var paramUserId = 0
    
    var arrayEvents = [[String:AnyObject]]()
    var arrayFavorites = [[String:AnyObject]]()
    var checkFavorites = [[String:AnyObject]]()
    
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        eventDetailImage.image = eventImage
        eventDetailName.text = eventName
        eventDetailDescription.text = eventDescription
        
        eventDetailPrice.text = eventPrice + " kn"
        eventDetailLink.setTitle(eventLink, for: .normal)
        
        if formatDate(eventEnd) == "" {
            eventDetailBegin.text = formatDate(eventBegin)
        }
        else {
            eventDetailBegin.text = formatDate(eventBegin) + "-" + formatDate(eventEnd)
        }*/
        
        eventId = TabMainViewController.eventId
        
        let userId = Int(self.defaults.string(forKey: "userId")!)
        
        paramEventId = Int(eventId)!
        paramUserId = userId!
        
        let eventParam = ["eventId": paramEventId] as [String:Any]
        
        let URLEvent = "http://vodickulturnihdogadanja.1e29g6m.xip.io/event.php"
        
        Alamofire.request(URLEvent, method: .get, parameters: eventParam).responseJSON {
            response in
            print(response)
            if let json = response.result.value as? NSDictionary{
                /*
                self.profile_Name = json["name"] as! String
                self.profile_Surname = json["surname"] as! String
                self.profile_Username = json["username"] as! String
                self.profile_Email = json["email"] as! String
                self.profile_Password = json["password"] as! String
                
                let imageString = json["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    self.profileImage.image = decodedImage
                }
                
                self.profileName.text = self.profile_Name
                self.profileSurname.text = self.profile_Surname
                self.profileUsername.text = self.profile_Username
                self.profileEmail.text = self.profile_Email
                */
                let imageString = json["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    self.eventImage = decodedImage
                }
                
                self.eventName = json["name"] as! String
                self.eventDescription = json["description"] as! String
                self.eventBegin = json["begin"] as! String
                self.eventEnd = json["end"] as! String
                self.eventPrice = json["price"] as! String
                self.eventLink = json["link"] as! String
                
                self.eventDetailImage.image = self.eventImage
                self.eventDetailName.text = self.eventName
                self.eventDetailDescription.text = self.eventDescription
                
                self.eventDetailPrice.text = self.eventPrice + " kn"
                self.eventDetailLink.setTitle(self.eventLink, for: .normal)
                
                if self.formatDate(self.eventEnd) == "" {
                    self.eventDetailBegin.text = self.formatDate(self.eventBegin)
                }
                else {
                    self.eventDetailBegin.text = self.formatDate(self.eventBegin) + "-" + self.formatDate(self.eventEnd)
                }
            }
            //self.viewDidLoad()
            //self.viewWillAppear(true)
        }
        
        let URLFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteList.php"
        
        let param = ["userId": paramUserId] as [String:Any]
        
        Alamofire.request(URLFavorites, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayFavorites = resData as! [[String:AnyObject]]
                }
                
            }
            
            let event = self.eventId
            
            self.checkFavorites = self.arrayFavorites.filter({ (array: [String:AnyObject]) -> Bool in
            if (array["eventId"]?.contains(event))! {
                    return true
                }
                else {
                    return false
                }
            })
            
            print(self.checkFavorites.count)
            if self.checkFavorites.count == 1 {
                self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(self.removeFromFavorites))
            }
            else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to favorites", style: .done, target: self, action: #selector(self.addToFavorites))
            }
        }
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
        
        if someDate == "" {
            return ""
        }
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datum = dateFromMilliseconds(date: dateInInt!)
        
        let konacniDatum = dateFormatter.string(from: datum)
        
        return konacniDatum
    }
    
    @objc private func addToFavorites() {
        
        let URLAddFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favorite.php"
        
        print(paramUserId)
        print(paramEventId)
        
        let paramsAdd: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
        ]
        
        Alamofire.request(URLAddFavorites, method: .post, parameters: paramsAdd, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(self.removeFromFavorites))
    }
    
    @objc private func removeFromFavorites() {
        let URLRemoveFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteDelete.php"
        
        paramEventId = Int(eventId)!
        
        let paramsRemove: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
            ]
        
        print(paramEventId)
        print(paramUserId)
        
        Alamofire.request(URLRemoveFavorites, method: .post, parameters: paramsRemove, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to favorites", style: .done, target: self, action: #selector(self.addToFavorites))
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
