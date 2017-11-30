//
//  RegistrationViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 30/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController {
    
    let URL_USER_REGISTER = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        
        if (userNameTextField.text == nil || (userNameTextField.text?.isEmpty)!) || (passwordTextField.text == nil || (passwordTextField.text?.isEmpty)!) || (emailTextField.text == nil || (emailTextField.text?.isEmpty)!) || (nameTextField.text == nil || (nameTextField.text?.isEmpty)!) || (surnameTextField.text == nil || (surnameTextField.text?.isEmpty)!) {
            let emptyFieldsAlert = UIAlertController(title: "You have empty fields.", message: nil, preferredStyle: .alert)
            emptyFieldsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyFieldsAlert, animated: true, completion: nil)
            return
        }
        
        let params: Parameters=[
            
            "username":userNameTextField.text!,
            "password":passwordTextField.text!,
            "email":emailTextField.text!,
            "name":nameTextField.text!,
            "surname":surnameTextField.text!,
            ]
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            print(response)
            let alertController = UIAlertController(title: "REGISTRATION SUCCESSFUL!", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
