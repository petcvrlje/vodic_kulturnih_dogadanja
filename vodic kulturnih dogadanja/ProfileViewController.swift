//
//  ProfileViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Faculty of Organisation and Informatics on 07/12/2017.
//  Copyright © 2017 foi. All rights reserved.
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
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileSurname: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profilePassword: UILabel!
    @IBOutlet weak var uiView: UIView!

    var arrayProfile = [[String:AnyObject]]()
    
    var profile_Image : UIImage? = nil
    var profile_Name = ""
    var profile_Surname = ""
    var profile_Username = ""
    var profile_Email = ""
    var profile_Password = ""

    profileImage.image = profile_Image
    profileName.text = profile_Name
    profileSurname.text = profile_Surname
    profileUsername.text = profile_Username
    profileEmail.text = profile_Email
    profilePassword.text = profile_Password
    
    let loginViewController = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URLUser = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        print(param)
        
        Alamofire.request(URLUser, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayProfile = resData as! [[String:AnyObject]]
                }
                if self.arrayProfile.count > 0 {
                    self.uiView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteTableViewCell
        var dict = arrayProfile[indexPath.row]
        
        let imageString = dict["picture"] as? String
        if let imageData = Data(base64Encoded: imageString!) {
            let decodedImage = UIImage(data: imageData)
            cell.favoriteImageView.image = decodedImage
        }
        
        cell.favoriteName.text = dict["name"] as? String
        cell.favoriteDescription.text = dict["description"] as? String
        
        
        return cell
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
