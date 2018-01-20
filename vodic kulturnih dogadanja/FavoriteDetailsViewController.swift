//
//  FavoriteDetailsViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 09/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire

class FavoriteDetailsViewController: UIViewController {
    
    @IBOutlet weak var favoriteDetailImage: UIImageView!
    @IBOutlet weak var favoriteDetailName: UILabel!
    @IBOutlet weak var favoriteDetailDescription: UILabel!
    @IBOutlet weak var favoriteDetailBegin: UILabel!
    @IBOutlet weak var favoriteDetailPrice: UILabel!
    @IBOutlet weak var favoriteDetailLink: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var favoriteImage : UIImage? = nil
    var favoriteName = ""
    var favoriteDescription = ""
    var favoriteBegin = ""
    var favoriteEnd = ""
    var favoritePrice = ""
    var favoriteLink = ""
    
    var favoriteId = ""
    
    let defaults = UserDefaults.standard
    
    var paramEventId = 0
    var paramUserId = 0
    
    @IBAction func linkButtonClicked(_ sender: UIButton) {
        let url = URL(string: favoriteLink)
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
        let date = dateFromMilliseconds(date: dateInInt!)
        
        let finalDate = dateFormatter.string(from: date)
        
        return finalDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = NSLocalizedString("date", comment: "")
        priceLabel.text = NSLocalizedString("price", comment: "")
        
        favoriteId = TabFavoritesViewController.eventId

        let userId = Int(self.defaults.string(forKey: "userId")!)
        
        paramEventId = Int(favoriteId)!
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
                    self.favoriteImage = decodedImage
                }
                
                self.favoriteName = json["name"] as! String
                self.favoriteDescription = json["description"] as! String
                self.favoriteBegin = json["begin"] as! String
                self.favoriteEnd = json["end"] as! String
                self.favoritePrice = json["price"] as! String
                self.favoriteLink = json["link"] as! String
                
                self.favoriteDetailImage.image = self.favoriteImage
                self.favoriteDetailName.text = self.favoriteName
                self.favoriteDetailDescription.text = self.favoriteDescription
                
                self.favoriteDetailPrice.text = self.favoritePrice + " kn"
                self.favoriteDetailLink.setTitle(self.favoriteLink, for: .normal)
                
                if self.formatDate(self.favoriteEnd) == "" {
                    self.favoriteDetailBegin.text = self.formatDate(self.favoriteBegin)
                }
                else {
                    self.favoriteDetailBegin.text = self.formatDate(self.favoriteBegin) + "h  -  " + self.formatDate(self.favoriteEnd) + "h"
                }
            }
            //self.viewDidLoad()
            //self.viewWillAppear(true)
        }
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(removeFromFavorites))
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "xicon.png"), style: .done, target: self, action: #selector(removeFromFavorites))
        
    }
    
    @objc private func removeFromFavorites() {
        let URLRemoveFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteDelete.php"
        
        paramEventId = Int(favoriteId)!
        paramUserId = Int(defaults.string(forKey: "userId")!)!
        
        let paramsRemove: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
            ]
        
        
        
        Alamofire.request(URLRemoveFavorites, method: .post, parameters: paramsRemove, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
        }
        

        navigationItem.rightBarButtonItem = nil
        
        dismiss(animated: true, completion: nil)
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
