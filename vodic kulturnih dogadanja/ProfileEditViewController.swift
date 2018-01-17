//
//  ProfileEditViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Faculty of Organisation and Informatics on 09/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileSurname: UITextField!
    @IBOutlet weak var profileUsername: UITextField!
    @IBOutlet weak var profilePassword: UITextField!
    @IBOutlet weak var profilePasswordNew: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var user = NSDictionary()
    var profile_Image = ""
    var profile_Email = ""
    var profile_Name = ""
    var new_Name = ""
    var profile_Surname = ""
    var new_Surname = ""
    var profile_Username = ""
    var new_Username = ""
    var profile_Password = ""
    var new_pass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = NSLocalizedString("name", comment: "")
        surnameLabel.text = NSLocalizedString("surname", comment: "")
        usernameLabel.text = NSLocalizedString("username", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)

        imagePicker.delegate = self
        
        let URLProfile = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        let defaults = UserDefaults.standard
        
        let userId = Int(defaults.string(forKey: "userId")!)
        
        let param = ["userId": userId!] as [String:Any]
        
        Alamofire.request(URLProfile, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if let json = response.result.value as? NSDictionary{
                self.profile_Email = json["email"] as! String
                self.profile_Name = json["name"] as! String
                self.profile_Surname = json["surname"] as! String
                self.profile_Username = json["username"] as! String
                self.profile_Password = json["password"] as! String
            }
        }
        
        viewWillAppear(true)
    }

    @IBAction func addPictureButtonClick(_ sender:UIButton){
        let alert = UIAlertController(title: "Choose one: ", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Photo library", style:.default, handler:{
        action in
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated:true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style:.default, handler: {
        action in
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated:true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",style:.cancel, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let jpegCompressionQuality: CGFloat = 0.9
        profileImage.image = image
        
        let image64 = UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString()
        
        profile_Image = image64!
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDataButton(_ sender: UIButton){
        
        let URLUpdate = "http://vodickulturnihdogadanja.1e29g6m.xip.io/userEdit.php"
        /*
        if  (profileName.text == nil || (profileName.text?.isEmpty)!) || (profileSurname.text == nil || (profileSurname.text?.isEmpty)!) || (profileUsername.text == nil || (profileUsername.text?.isEmpty)!) {
            let emptyFieldsAlert = UIAlertController(title: "You have empty fields.", message: nil, preferredStyle: .alert)
            emptyFieldsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyFieldsAlert, animated: true, completion: nil)
            return
        }*/
        
        if(profilePassword.text != profilePasswordNew.text){
            let passDontMatch = UIAlertController(title: "Your passwords do not match.", message: nil, preferredStyle: .alert)
            passDontMatch.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(passDontMatch, animated: true, completion: nil)
            return
        }
        
        if(profilePassword.text != profile_Password){
            new_pass = profilePassword.text!
        }
        else{
            new_pass = profile_Password
        }
        
        if(profileName.text != profile_Name){
            new_Name = profileName.text!
        }
        else{
            new_Name = profile_Name
        }
        
        if(profileUsername.text != profile_Username){
            new_Username = profileUsername.text!
        }
        else{
            new_Username = profile_Username
        }
        
        if(profileSurname.text != profile_Surname){
            new_Surname = profileSurname.text!
        }
        else{
            new_Surname = profile_Surname
        }
        
        
        let params: Parameters=[
            "username":new_Username,
            "name":new_Name,
            "surname":new_Surname,
            "password":new_pass,
            "email":profile_Email,
            "picture": profile_Image
        ]
        
        Alamofire.request(URLUpdate, method: .post, parameters: params, encoding: JSONEncoding.default).responseString {
            (response) in
            print(response)
            
            
            let alertController = UIAlertController(title: "Data changed!", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
