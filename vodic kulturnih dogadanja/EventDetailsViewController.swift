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

protocol SocialShare {
    func share(network: String, link:String, vc: UIViewController)
}

class EventDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var eventDetailName: UILabel!
    @IBOutlet weak var eventDetailDescription: UILabel!
    @IBOutlet weak var eventDetailBegin: UILabel!
    @IBOutlet weak var eventDetailPrice: UILabel!
    @IBOutlet weak var eventDetailLink: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

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
        
        dateLabel.text = NSLocalizedString("date", comment: "")
        priceLabel.text = NSLocalizedString("price", comment: "")
        self.tabBarController?.tabBar.items![0].title = NSLocalizedString("tabDetails", comment: "")
        self.tabBarController?.tabBar.items![1].title = NSLocalizedString("tabComments", comment: "")
        
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
                    self.eventDetailBegin.text = self.formatDate(self.eventBegin) + "h  -  " + self.formatDate(self.eventEnd) + "h"
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
                //let removeFavoriteButton = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(self.removeFromFavorites))
                let removeFavoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "removeFavorite.png"), style: .done, target: self, action:  #selector(self.removeFromFavorites))
                let shareEventButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareEvent))
                self.tabBarController?.navigationItem.rightBarButtonItems = [shareEventButton, removeFavoriteButton]
            }
            else {
                //let addFavoriteButton = UIBarButtonItem(title: "Add to favorites", style: .done, target: self, action: #selector(self.addToFavorites))
                let addFavoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addFavorite.png"), style: .done, target: self, action:  #selector(self.addToFavorites))
                let shareEventButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareEvent))
                self.tabBarController?.navigationItem.rightBarButtonItems = [shareEventButton, addFavoriteButton]
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
        dateFormatter.dateFormat = "dd.MM.YYYY. HH:mm"
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
        
        let removeFavoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "removeFavorite.png"), style: .done, target: self, action:  #selector(self.removeFromFavorites))
        let shareEventButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareEvent))
        self.tabBarController?.navigationItem.rightBarButtonItems = [shareEventButton, removeFavoriteButton]
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
        
        let addFavoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addFavorite.png"), style: .done, target: self, action:  #selector(self.addToFavorites))
        let shareEventButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareEvent))
        self.tabBarController?.navigationItem.rightBarButtonItems = [shareEventButton, addFavoriteButton]
    }
    
    @objc private func shareEvent() {
        let actionSheetController = UIAlertController(title: "Choose where to share.", message: nil, preferredStyle: .actionSheet)
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { (action) in
            let facebook: SocialShare = Facebook()
            facebook.share(network: "Facebook", link: "http://vodickulturnihdogadanja.1e29g6m.xip.io/webPage/events.php?eventId=\(self.eventId)", vc: self.navigationController!)
        }
        let twitterAction = UIAlertAction(title: "Twitter", style: .default) { (action) in
            let twitter : SocialShare = Twitter()
            twitter.share(network: "Twitter", link: "http://vodickulturnihdogadanja.1e29g6m.xip.io/webPage/events.php?eventId=\(self.eventId)", vc: self.navigationController!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheetController.addAction(facebookAction)
        actionSheetController.addAction(twitterAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func dislikeEvent(_ sender: UIButton) {
        let URLUpdate = "http://vodickulturnihdogadanja.1e29g6m.xip.io/evaluation.php"
        
        let dislike = 0
        
        let paramsDislike: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
            "mark": dislike
        ]
        
        Alamofire.request(URLUpdate, method: .post, parameters: paramsDislike, encoding: JSONEncoding.default).responseString {
            (response) in
            print(response)
            
        }
    }
    
    @IBAction func likeEvent(_ sender: UIButton) {
    
        let URLUpdate = "http://vodickulturnihdogadanja.1e29g6m.xip.io/evaluation.php"
        
        let like = 1
        
        let paramsLike: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
            "mark": like
        ]
        
        Alamofire.request(URLUpdate, method: .post, parameters: paramsLike, encoding: JSONEncoding.default).responseString {
            (response) in
            print(response)
            
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
