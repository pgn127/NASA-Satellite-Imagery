//
//  ViewController.swift
//  NASAassignment
//
//  Created by Pamela Needle on 10/13/15.
//  Copyright © 2015 Pamela Needle. All rights reserved.
//

import UIKit

class SatelliteViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    let apikey = "OGmwUxiA5mcUEyGDMZVIQzkaTh1WL4OM59kA9Qy7"
    @IBOutlet weak var datelabel: UITextView!
    var longitute: String?
    var latitude: String?
    var imageurl: String?
    var datestring: String?
    var cloudscore = true
    let baseURL = "https://api.nasa.gov/planetary/earth/imagery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("ran request")
        //var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: baseURL))
        performNASARequest("150.8931239", latitude: "-34.424984", date: "2015-05-01")
        //print("ran request")
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
    
    func performNASARequest(longitude: String, latitude: String, date: String) {
        let urlComponents = NSURLComponents(string: baseURL)
        let lonQuery: NSURLQueryItem = NSURLQueryItem(name: "lon", value: longitude)
        let latQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: latitude)
        let dateQuery: NSURLQueryItem = NSURLQueryItem(name: "date", value: date)
        let cloudQuery: NSURLQueryItem = NSURLQueryItem(name: "cloud_score", value: "True")
        let  keyQuery: NSURLQueryItem = NSURLQueryItem(name: "api_key", value: apikey)
        //components.lat = latitude
        //components.lon = longitude
        urlComponents!.queryItems = [lonQuery, latQuery, dateQuery, cloudQuery, keyQuery]
        
        let url = urlComponents?.URL
        //print("url is: \(url)")
        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) -> Void in
                if error != nil {
                    print("Error trying to GET from NASA \(error)")
                } else if let d = data, let r = response {
                    let result = NSString(data: d, encoding:NSASCIIStringEncoding)!
                    //print("query result \(result)")
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.AllowFragments )
                        guard let dict : NSDictionary = json as? NSDictionary else {
                            print("not a dictionary")
                            return
                        }
                        if let date = dict["date"] as? String, img = dict["url"] as? String{
                            self.datestring = date
                            //self.datelabel.text = self.datestring
                            self.imageurl = img
                            self.fetchImage(img)
                            //print("imageurl: \(self.imageurl)")
                            
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
    
    
    func fetchImage(urlString: String){
        //will load remote image into memory and then display image in imageview

        
        if let url = NSURL(string: urlString){
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                
                if error != nil {
                    print("error with image url")
                }
                else if let d = data {
                    print("loading image into the picture")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.img.image = UIImage(data: d)
                        self.img.contentMode = UIViewContentMode.ScaleAspectFit
                    })
                    
                }
                
            })
            task.resume()
        }
       
        

        
            
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
