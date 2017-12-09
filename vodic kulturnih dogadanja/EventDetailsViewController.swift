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
    
    
    var eventImage : UIImage? = nil
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
    
    var arrayFavorites = [[String:AnyObject]]()
    var checkFavorites = [[String:AnyObject]]()
    
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        
        let URLFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteList.php"
        
        let userId = Int(self.defaults.string(forKey: "userId")!)
        
        paramEventId = Int(eventId)!
        paramUserId = userId!
        
        let param = ["userId": userId!] as [String:Any]
        
        Alamofire.request(URLFavorites, method: .get, parameters: param).responseJSON {
            response in
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayFavorites = resData as! [[String:AnyObject]]
                }
                
            }
            
            
            self.checkFavorites = self.arrayFavorites.filter({ (array: [String:AnyObject]) -> Bool in
            if (array["eventId"]?.contains(self.eventId))! {
                    return true
                }
                else {
                    return false
                }
            })
            
            if self.checkFavorites.count == 1 {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(self.removeFromFavorites))
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(self.removeFromFavorites))
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add to favorites", style: .done, target: self, action: #selector(self.addToFavorites))
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
