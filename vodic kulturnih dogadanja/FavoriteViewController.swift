//
//  FavoriteViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 06/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayFavorites = [[String:AnyObject]]()
    
    func dateFromMilliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("menuFavorites", comment: "")

        let URLFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteList.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        print(param)
        
        Alamofire.request(URLFavorites, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayFavorites = resData as! [[String:AnyObject]]
                }
        
                if self.arrayFavorites.count > 0 {
                    self.tableView.reloadData()
                }
            }
            //self.viewWillAppear(true)
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteTableViewCell
        var dict = arrayFavorites[indexPath.row]
        
        let imageString = dict["picture"] as? String
        if let imageData = Data(base64Encoded: imageString!) {
            let decodedImage = UIImage(data: imageData)
            cell.favoriteImageView.image = decodedImage
        }
        
        cell.favoriteName.text = dict["name"] as? String
        cell.favoriteDescription.text = dict["description"] as? String
        
        let begin = formatDate(dict["begin"] as! String)
        let end = formatDate(dict["end"] as! String)
        
        if end == "0" {
            cell.favoriteBegin.text = begin
        }
        else {
            cell.favoriteBegin.text = begin + "h  -  " + end + "h"
        }
        
        return cell
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "favoriteDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let favoriteEvent = arrayFavorites[indexPath.row]
                
                TabFavoritesViewController.eventId = favoriteEvent["eventId"] as! String
                
            }
        }
    }
    

}
