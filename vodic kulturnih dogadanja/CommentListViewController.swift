//
//  CommentListViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Petra Cvrljevic on 17/12/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var addCommentButton: UIButton!
    
    var arrayComments = [[String:AnyObject]]()
    var eventId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCommentButton.setTitle(NSLocalizedString("addComment", comment: ""), for: .normal)

        let URL = "http://vodickulturnihdogadanja.1e29g6m.xip.io/commentList.php"
        
        let paramEvent = Int(TabMainViewController.eventId)!
        let param = ["eventId": paramEvent] as [String:Any]
        
        Alamofire.request(URL, parameters: param).responseJSON {
            response in
            //print(response)
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                //print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.arrayComments = resData as! [[String:AnyObject]]
                }
                if self.arrayComments.count > 0 {
                    self.tableView.reloadData()
                }
            }
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentListTableViewCell
        
        var comment = arrayComments[indexPath.row]
        
        let userId = Int(UserDefaults.standard.string(forKey: "userId")!)
        let param = ["userId": userId!] as [String:Any]
        
        let URLUser = "http://vodickulturnihdogadanja.1e29g6m.xip.io/user.php"
        
        Alamofire.request(URLUser, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if let json = response.result.value as? NSDictionary {
                cell?.commentUser.text = json["username"] as? String
            }
        }
        
        cell?.commentText.text = comment["text"] as? String
        cell?.commentTime.text = formatDate((comment["time"] as? String)!)
        
        return cell!
    }
    
    func currentDateInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970*1000)
    }
    
    func dateFromMilliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func formatDate(_ someDate: String) -> String {
        
        if someDate == "" {
            return ""
        }
        let dateInInt = Int(someDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datum = dateFromMilliseconds(date: dateInInt!)
        
        let konacniDatum = dateFormatter.string(from: datum)
        
        return konacniDatum
    }
    
    @IBAction func addCommentPressed(_ sender: UIButton) {
        
        let userId = Int(UserDefaults.standard.string(forKey: "userId")!)
        let paramUserId = userId!
        let paramEventId = Int(TabMainViewController.eventId)!
        let paramText = text.text!
        let paramTime = currentDateInMiliseconds()
        
         let URLAddComment = "http://vodickulturnihdogadanja.1e29g6m.xip.io/comment.php"
        
        let params: Parameters=[
            "userId":paramUserId,
            "eventId":paramEventId,
            "text":paramText,
            "time":paramTime,
            ]
        
        Alamofire.request(URLAddComment, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            print(response)
        }
        
        text.text = ""
        tableView.reloadData()
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
