//
//  UnregisteredSideMenuTableViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 09/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

///Class for side menu for unregistered user 
class UnregisteredSideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var unregisteredHomeLabel: UILabel!
    @IBOutlet weak var unregisteredSignUpLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unregisteredHomeLabel.text = NSLocalizedString("menuHome", comment: "")
        unregisteredSignUpLabel.text = NSLocalizedString("unregisteredMenuSignUp", comment: "")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "unregisteredContainter")
            self.present(vc!, animated: true, completion: nil)
        }

        else if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUp")
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
