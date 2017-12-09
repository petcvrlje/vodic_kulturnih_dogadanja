//
//  SideMenuVC.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire

class SideMenuVC: UITableViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameSurname: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var user_Image : UIImage? = nil
    var user_Name = ""
    var user_Surname = ""
    var user_Email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URLProfile = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        
        Alamofire.request(URLProfile, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            
            if let json = response.result.value as? NSDictionary{
                self.user_Name = json["name"] as! String
                self.user_Surname = json["surname"] as! String
                self.user_Email = json["email"] as! String
                
                let imageString = json["picture"] as? String
                    if let imageData = Data(base64Encoded: imageString!) {
                        let decodedImage = UIImage(data: imageData)
                        self.user_Image = decodedImage
                    }
                self.userImage.image = self.user_Image
                self.userNameSurname.text = self.user_Name + " " + self.user_Surname
                self.userEmail.text = self.user_Email
                }
            }
        //viewWillAppear(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerProfileVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerFavoritesVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
            //settings
        }
        else if indexPath.row == 5{
            
        }
        else if indexPath.row == 6 {
            UserDefaults.standard.set(nil, forKey: "tokenId")
            UserDefaults.standard.set(nil, forKey: "userId")

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "firstScreen")
            self.present(vc!, animated: true, completion: nil)
        }
    }

    
}
