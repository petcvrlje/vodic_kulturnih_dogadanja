//
//  SideMenuVC.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerProfileVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "containerFavoritesVC")
            self.present(vc!, animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
            //settings
        }
        else if indexPath.row == 5{
            
        }
        else if indexPath.row == 6 {
            UserDefaults.standard.set(nil, forKey: "tokenId")
            UserDefaults.standard.set(nil, forKey: "userId")

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "firstScreen")
            self.present(vc!, animated: true, completion: nil)
        }
    }

    
}
