//
//  MapViewController.swift
//  vodic kulturnih dogadanja
//
//  Created by Faculty of Organisation and Informatics on 21/01/2018.
//  Copyright © 2018 foi. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import SwiftyJSON
import CoreLocation
import MapKit

///Class for showing event location on map
class MapViewController: UIViewController {

    ///Getting event location and showing it on map 
    override func viewDidLoad() {
        super.viewDidLoad()

        let URLEvent = "http://vodickulturnihdogadanja.1e29g6m.xip.io/event.php"
        let eventId = TabMainViewController.eventId
        
        let param = ["eventId": eventId] as [String:Any]
        
        Alamofire.request(URLEvent, method: .get, parameters: param).responseJSON {
            response in
            print(response)
            if let json = response.result.value as? NSDictionary{
                let address = json["location"] as! String
                
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address) { (placemarks, error) in
                    if (error != nil) {
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                        
                        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16.0)
                        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                        self.view = mapView
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        marker.title = address
                        marker.map = mapView
                    }

                }
            }
        }
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
