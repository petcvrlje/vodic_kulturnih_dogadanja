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
    
    var arrayUser = [[String:AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URLProfile = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        print(param)
        
        
        Alamofire.request(URLProfile, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if (response.result.value != nil){
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject{
                    self.arrayUser = resData as! [[String:AnyObject]]
                    
                    self.profile_Name = self.arrayUser[0]["name"] as! String
                    }
                }
            
    
            }
        }
        /*profileImage.image = profile_Image
        profileName.text = profile_Name
        profileSurname.text = profile_Surname
        profileUsername.text = profile_Username
        profileEmail.text = profile_Email
        profilePassword.text = profile_Password
 
        
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
