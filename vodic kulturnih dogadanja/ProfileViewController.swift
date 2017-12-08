//
//  ProfileViewController.swift
//
//
//  Created by Faculty of Organisation and Informatics on 07/12/2017.
//

import UIKit
import Alamofire
import SwiftyJSON


class ProfileViewController: UIViewController {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileSurname: UITextField!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileUsername: UITextField!
    @IBOutlet weak var profileEmail: UITextField!
    @IBOutlet weak var profilePassword: UITextField!
    
    
    
    var profile_Image : UIImage? = nil
    var profile_Name = ""
    var profile_Surname = ""
    var profile_Username = ""
    var profile_Email = ""
    var profile_Password = ""
    
    var user = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URLProfile = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        //print(param)
        
        
        Alamofire.request(URLProfile, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if let json = response.result.value as? NSDictionary{
                self.profile_Name = json["name"] as! String
                self.profile_Surname = json["surname"] as! String
                self.profile_Username = json["username"] as! String
                self.profile_Email = json["email"] as! String
                //self.profile_Image = json["picture"] as! UIImage
              
                let imageString = json["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    self.profileImage.image = decodedImage
                }
                
                self.profileName.text = self.profile_Name
                self.profileSurname.text = self.profile_Surname
                self.profileUsername.text = self.profile_Username
                self.profileEmail.text = self.profile_Email
            }
        }
        
        viewWillAppear(true)
        
        
    }
    
     
     
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
