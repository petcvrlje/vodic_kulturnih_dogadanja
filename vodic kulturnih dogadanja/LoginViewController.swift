//
//  LoginViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 15/11/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
//import HTTPStatusCodes

class LoginViewController: UIViewController {

    let URL_USER_LOGIN = "http://vodickulturnihdogadanja.1e29g6m.xip.io/userLogIn.php"
    
    let defaultValues = UserDefaults.standard
    
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
        
        let params: Parameters=[
            "username":userNameTextField.text!,
            "password":passwordTextField.text!,
        ]
        
        
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
            let statusCode = (response.response?.statusCode)!
            print(statusCode)
            
            if let result = response.result.value as? Dictionary<String, String> {
                self.defaultValues.set(result["tokenId"]!, forKey: "tokenId")
            }
            else {
                let alertController = UIAlertController(title: "LOGIN UNSUCCESSFUL", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
