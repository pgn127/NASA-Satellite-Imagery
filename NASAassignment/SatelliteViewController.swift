//
//  ViewController.swift
//  NASAassignment
//
//  Created by Pamela Needle on 10/13/15.
//  Copyright © 2015 Pamela Needle. All rights reserved.
//

import UIKit

class SatelliteViewController: UIViewController {
    
    let apikey = "EfDLSUrWJxYXtgqCyXNz14y9QQYSBaZm8DpBwMWg"
    var longitute: String?
    var latitude: String?
    var imageurl: String?
    var datestring: String?
    let baseURL = "https://api.nasa.gov/planetary/earth/imagery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: baseURL))
        performNASARequest("0", longitude: "0", date: "2014-02-02")
        print("ran request")
        //            (data, error) -> Void in
        //            if error != nil {
        //                println(error)
        //            } else {
        //                println(data)
        //            }
        //        }
        
        //request.timeoutInterval = 5
        //request.HTTPMethod = "GET"/// ?
        //let task = session.dataTaskWithRequest(request){
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //        performNASARequest("0", longitude: "0", date: "2014-02-02")
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performNASARequest(latitude: String, longitude: String, date: String) {
        let urlComponents = NSURLComponents(string: baseURL)
        let latQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: latitude)
        let lonQuery: NSURLQueryItem = NSURLQueryItem(name: "lon", value: longitude)
        //components.lat = latitude
        //components.lon = longitude
        urlComponents!.queryItems = [latQuery, lonQuery]
        
        let url = urlComponents?.URL
        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) -> Void in
                if error != nil {
                    print("Error trying to GET from NASA \(error)")
                } else if let d = data, let r = response{
                    var result = NSString(data: d, encoding:NSASCIIStringEncoding)!
                    print("query result \(result)")
                    //var error:NSError? = nil
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.AllowFragments )
                        guard let dict : NSDictionary = json as? NSDictionary else {
                            print("not a dictionary")
                            return
                        }
                        if let date = dict["date"] as? String, img = dict["url"] as? String{
                            self.datestring = date
                            self.imageurl = img
                            
                        }  else{
                            print("date and image not found in json string")
                        }
                        
                        
                    } catch {
                        print("json error")
                    }
                }
                
        })
        print("perform function reached")
        task.resume()
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
