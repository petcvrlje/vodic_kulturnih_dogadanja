//
//  UnregisteredSideMenuTableViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 09/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class UnregisteredSideMenuTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "unregisteredContainter")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 1 {
            
        }
        else if indexPath.row == 2 {
            
        }
        else if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signUp")
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
