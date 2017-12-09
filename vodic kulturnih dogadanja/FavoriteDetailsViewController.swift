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
    @IBOutlet weak var favoriteDetailEnd: UILabel!
    @IBOutlet weak var favoriteDetailPrice: UILabel!
    @IBOutlet weak var favoriteDetailLink: UIButton!
    
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
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFromMilliseconds(date: dateInInt!)
        
        let finalDate = dateFormatter.string(from: date)
        
        return finalDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteDetailImage.image = favoriteImage
        favoriteDetailName.text = favoriteName
        favoriteDetailDescription.text = favoriteDescription
        favoriteDetailBegin.text = formatDate(favoriteBegin)
        favoriteDetailEnd.text = formatDate(favoriteEnd)
        favoriteDetailPrice.text = favoritePrice + " kn"
        favoriteDetailLink.setTitle(favoriteLink, for: .normal)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove from favorites", style: .done, target: self, action: #selector(removeFromFavorites))
        
    }
    
    @objc private func removeFromFavorites() {
        let URLRemoveFavorites = "http://vodickulturnihdogadanja.1e29g6m.xip.io/favoriteDelete.php"
        
        paramEventId = Int(favoriteId)!
        paramUserId = Int(defaults.string(forKey: "userId")!)!
        
        let paramsRemove: Parameters=[
            "eventId":paramEventId,
            "userId":paramUserId,
            ]
        
        
        
        Alamofire.request(URLRemoveFavorites, method: .post, parameters: paramsRemove).responseJSON {
            response in
            print(response)
        }
        
        navigationItem.rightBarButtonItem = nil
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
