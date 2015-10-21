//
//  MapViewController.swift
//  NASAassignment
//
//  Created by Pamela Needle on 10/19/15.
//  Copyright © 2015 Pamela Needle. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var currentLat : Double?
    var currentLong : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        
        self.mapView.delegate = self
        
        let press = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        press.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(press)
        viewButton.alpha = 0

        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        <#code#>
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(gestureRec: UIGestureRecognizer){
        if gestureRec.state == UIGestureRecognizerState.Began{
            if(mapView.annotations.count != 0){
                mapView.removeAnnotations(mapView.annotations)
            }
            let touchPoint = gestureRec.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            currentLat = newCoordinates.latitude
            currentLong = newCoordinates.longitude
           
            
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
            viewButton.alpha = 1
        }
    }
//            annotation.coordinate = newCoordinates
//            
//            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks,error) -> Void in
//                if error != nil {
//                    print("reverse geocoder error")
//                    return
//                }
//                
//                if placemarks.count > 0 {
//                    let pm = placemarks[0] as! CLPlacemark
//                    annotation.title = pm.thoroughfare + "," + pm.subThoroughfare
//                    annotation.subtitle = pm.subLocality
//                    self.mapView.addAnnotation(annotation)
//                    print(pm)
//                    
//                } else {
//                    annotation.title = "Uknown place"
//                    self.mapView.addAnnotation(Annotation)
//                }
//                places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
//            })
//        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Details" {
        if let long = currentLong, lat = currentLat {
            return true
        }
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("prepare for Segue called")
        if segue.identifier == "Details" {
            print("long and lat exist")
        //let vC = self.navigationController?.popViewControllerAnimated(true) as! SatelliteViewController
            let vC = segue.destinationViewController as! SatelliteViewController
            vC.longitude = String(format:"%f", currentLong!)
            vC.latitude = String(format:"%f", currentLat!)
        }
    }

    @IBAction func viewLoc(sender: AnyObject) {
       // self.performSegueWithIdentifier("Details", sender: sender)
    }
    
    
    
}
