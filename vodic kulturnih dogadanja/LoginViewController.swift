//
//  LoginViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 15/11/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    let URL_USER_LOGIN = "http://vodickulturnihdogadanja.1e29g6m.xip.io/userLogIn.php"
    
    let defaultValues = UserDefaults.standard
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        //provjera
        if (userNameTextField.text == nil || (userNameTextField.text?.isEmpty)!) || (passwordTextField.text == nil || (passwordTextField.text?.isEmpty)!) {
            let emptyFieldsAlert = UIAlertController(title: "You have empty fields.", message: nil, preferredStyle: .alert)
            emptyFieldsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyFieldsAlert, animated: true, completion: nil)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let deviceId = appDelegate?.tokenId
        
        let params: Parameters=[
            "username":userNameTextField.text!,
            "password":passwordTextField.text!,
            "deviceId": deviceId!,
        ]
        
        
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
            let statusCode = (response.response?.statusCode)!
            print(statusCode)
            
            if (statusCode != 200) {
                let alertController = UIAlertController(title: "LOGIN UNSUCCESSFUL", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else {
                if let result = response.result.value as? Dictionary<String, String> {
                    self.defaultValues.set(result["tokenId"]!, forKey: "tokenId")
                    self.defaultValues.set(result["userId"]!, forKey: "userId")
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "containerVC")
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = NSLocalizedString("username", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        registerButton.setTitle(NSLocalizedString("register", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        
        userNameTextField.placeholder = NSLocalizedString("usernamePlaceholder", comment: "")
        passwordTextField.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
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
