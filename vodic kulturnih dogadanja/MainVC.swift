//
//  MainVC.swift
//  vodic kulturnih dogadanja
//
//  Created by MTLab on 29/10/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift

///Main class for events. Main screen when user is logged in.
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBAction func onMoreTapped(){
        print("Toggle side menu")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activeEvents = [[String:AnyObject]]()
    var allEvents = [[String:AnyObject]]()
    var filteredActiveEvents = [[String:AnyObject]]()
    var filteredAllEvents = [[String:AnyObject]]()

    var inSearchMode = false
    
    func currentDateInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970*1000)
    }
    
    ///Seting up search bar, geting data for active events and all events and showing them on screen.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menuHome".localized()
        
        setupSearchBar()
        
        let dateInMiliseconds = currentDateInMiliseconds()
        let URL = "http://vodickulturnihdogadanja.1e29g6m.xip.io/eventList.php"
        
        let param = ["begin": dateInMiliseconds, "keyword": ""] as [String:Any]
        
        Alamofire.request(URL, parameters: param).responseJSON {
            response in
            if ((response.result.value) != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                //print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar[].arrayObject {
                    self.activeEvents = resData as! [[String:AnyObject]]
                    self.filteredActiveEvents = self.activeEvents
                }
                if self.activeEvents.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
        
        let URLAllEvents = "http://vodickulturnihdogadanja.1e29g6m.xip.io/eventListAll.php"
        
        Alamofire.request(URLAllEvents).responseJSON {
            response in
            if ((response.result.value) != nil) {
                let swiftyJSONVar = JSON(response.result.value!)
                if let resData = swiftyJSONVar[].arrayObject {
                    self.allEvents = resData as! [[String:AnyObject]]
                    self.filteredAllEvents = self.allEvents
                }
                if self.allEvents.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func dateFromMiliseconds(date: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(date)/1000)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var returnValue = 1
        
        if (searchBar.text?.isEmpty)! {
            switch searchBar.selectedScopeButtonIndex {
            case 0: returnValue = activeEvents.count
            case 1: returnValue = allEvents.count
            default: print("Error")
            }
        }
        else {
            switch searchBar.selectedScopeButtonIndex {
            case 0: returnValue = filteredActiveEvents.count
            case 1: returnValue = filteredAllEvents.count
            default: print("Error")
            }
        }
        
        print("Return value: \(returnValue)")
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainEventsCell")! as? RegisteredEventTableViewCell
        
        if (searchBar.text?.isEmpty)! {
            
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                var events = activeEvents[indexPath.row]
                
                let imageString = events["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    cell?.eventImageView.image = decodedImage
                }
                
                cell?.nameLabel.text = events["name"] as? String
                cell?.descriptionLabel.text = events["description"] as? String
                
                let begin = formatDate(events["begin"] as! String)
                let end = formatDate(events["end"] as! String)
                
                if end == "0" {
                    cell?.beginLabel.text = begin
                }
                else {
                    cell?.beginLabel.text = begin + "h  -  " + end + "h"
                }
            case 1:
                var eventsAll = allEvents[indexPath.row]
                
                let imageString = eventsAll["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    cell?.eventImageView.image = decodedImage
                }
                
                cell?.nameLabel.text = eventsAll["name"] as? String
                cell?.descriptionLabel.text = eventsAll["description"] as? String
                
                let begin = formatDate(eventsAll["begin"] as! String)
                let end = formatDate(eventsAll["end"] as! String)
                
                if end == "0" {
                    cell?.beginLabel.text = begin
                }
                else {
                    cell?.beginLabel.text = begin + "h  -  " + end + "h"
                }
            default:
                print("Error")
            }
        }
        else {
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                var filtered = filteredActiveEvents[indexPath.row]
                
                let imageString = filtered["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    cell?.eventImageView.image = decodedImage
                }
                
                cell?.nameLabel.text = filtered["name"] as? String
                cell?.descriptionLabel.text = filtered["description"] as? String
                
                let begin = formatDate(filtered["begin"] as! String)
                let end = formatDate(filtered["end"] as! String)
                
                if end == "0" {
                    cell?.beginLabel.text = begin
                }
                else {
                    cell?.beginLabel.text = begin + "h  -  " + end +  "h"
                }
            case 1:
                var dict = filteredAllEvents[indexPath.row]
                
                let imageString = dict["picture"] as? String
                if let imageData = Data(base64Encoded: imageString!) {
                    let decodedImage = UIImage(data: imageData)
                    cell?.eventImageView.image = decodedImage
                }
                
                cell?.nameLabel.text = dict["name"] as? String
                cell?.descriptionLabel.text = dict["description"] as? String
                
                
                let begin = formatDate(dict["begin"] as! String)
                let end = formatDate(dict["end"] as! String)
                
                if end == "0" {
                    cell?.beginLabel.text = begin
                }
                else {
                    cell?.beginLabel.text = begin + "h  -  " + end + "h"
                }
            default:
                print("Error")
            }
        }
        
        return cell!
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
        dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
        let date = dateFromMilliseconds(date: dateInInt!)
        
        let finalDate = dateFormatter.string(from: date)
        
        return finalDate
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.isEmpty) {
            inSearchMode = false
            view.endEditing(true)
            filteredActiveEvents = activeEvents
            filteredAllEvents = allEvents
            tableView.reloadData()
        }
        else {
            inSearchMode = true
            filterTableView(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if (searchBar.text?.isEmpty)! {
            inSearchMode = false
            view.endEditing(true)
            filteredActiveEvents = activeEvents
            filteredAllEvents = allEvents
            tableView.reloadData()
        }
        else {
            inSearchMode = true
            filterTableView(index: selectedScope, text: searchBar.text!)
        }
        
    }
    
    ///Setting up searchbar
    func setupSearchBar() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["activeEvents".localized(), "allEvents".localized()]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.placeholder = "searchBar".localized()
    }
    
    ///Filtering results by event name 
    func filterTableView(index: Int, text: String) {
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            filteredActiveEvents = activeEvents.filter({ (array: [String:AnyObject]) -> Bool in
                return (array["name"]?.lowercased.contains(text.lowercased()))!
            })
            self.tableView.reloadData()
        case 1:
            filteredAllEvents = allEvents.filter({ (array: [String:AnyObject]) -> Bool in
                return (array["name"]?.lowercased.contains(text.lowercased()))!
            })
            self.tableView.reloadData()
        default:
            print("Error")
        }
    }
    
    ///Preparing segue for forwarding event id
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "eventDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                if (searchBar.text?.isEmpty)! {
                    switch searchBar.selectedScopeButtonIndex {
                    case 0:
                        var event = activeEvents[indexPath.row]
                        TabMainViewController.eventId = event["eventId"] as! String
                    
                    case 1:
                        var event = allEvents[indexPath.row]
                        TabMainViewController.eventId = event["eventId"] as! String
                    
                    default: print("Error")
                    }
                }
                else {
                    switch searchBar.selectedScopeButtonIndex {
                    case 0:
                        var event = filteredAllEvents[indexPath.row]
                        TabMainViewController.eventId = event["eventId"] as! String
                    case 1:
                        var event = filteredAllEvents[indexPath.row]
                        TabMainViewController.eventId = event["eventId"] as! String
                    default: print("Error")
                    }
                }
                
                
            }
        }
    }
}
