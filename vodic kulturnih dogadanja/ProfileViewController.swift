//
//  ProfileViewController.swift
//
//
//  Created by Faculty of Organisation and Informatics on 07/12/2017.
//

import UIKit
import Alamofire
import SwiftyJSON


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
        
    }
    
    let imagePicker:UIImagePickerController = UIImagePickerController()

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileSurname: UITextField!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileUsername: UITextField!
    @IBOutlet weak var profileEmail: UITextField!
    @IBOutlet weak var profilePassword: UITextField!
    @IBOutlet weak var profilePasswordNew: UITextField!
    
    
    
    var profile_Image = ""
    var profile_Name = ""
    var profile_Surname = ""
    var profile_Username = ""
    var profile_Email = ""
    var profile_Password = ""
    
    var user = NSDictionary()
    
    override func viewDidLoad() {
        
        imagePicker.delegate = self
        
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
                self.profile_Password = json["password"] as! String
              
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
    
    
    @IBAction func updateDataButtonSave(_ sender:UIButton){
        
        let URLUpdate = "http://vodickulturnihdogadanja.1e29g6m.xip.io/userEdit.php"

        if  (profileName.text == nil || (profileName.text?.isEmpty)!) || (profileSurname.text == nil || (profileSurname.text?.isEmpty)!) {
            let emptyFieldsAlert = UIAlertController(title: "You have empty fields.", message: nil, preferredStyle: .alert)
            emptyFieldsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyFieldsAlert, animated: true, completion: nil)
            return
        }
        
        if(profilePassword.text != profilePasswordNew.text){
            let passDontMatch = UIAlertController(title: "Your passwords do not match.", message: nil, preferredStyle: .alert)
            passDontMatch.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(passDontMatch, animated: true, completion: nil)
            return
        }
        
        let params: Parameters=[
            "username":profileUsername.text!,
            "name":profileName.text!,
            "surname":profileSurname.text!,
            "password":profile_Password,
            "email":profileEmail.text!,
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
    @IBAction func cancelDataChange(_ sender: UIButton){
        viewDidLoad()
        viewWillAppear(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
