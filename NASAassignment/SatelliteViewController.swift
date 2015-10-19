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
    
    @IBOutlet weak var datelabel: UILabel!
    var longitude: String?
    var latitude: String?
    //var imageurl: String?
    //var datestring: String?
    var counter: Int = 7
    var loadingComplete: Bool = false
    var locHistory = [locInfo?](count: 7, repeatedValue: nil)
    var locIndex: Int?
    var cloudscore = true
    let baseURL = "https://api.nasa.gov/planetary/earth/imagery"
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.longitude = "-0.1276250"
        self.latitude = "51.5033630"

        performNASARequestSequence(longitude!, latitude: latitude!)
        
                actInd.center = self.view.center
                actInd.hidesWhenStopped = true
                actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                view.addSubview(actInd)
        
        actInd.startAnimating()
        
        
        
//        if loadingComplete{
//        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("displayImages"), userInfo: nil, repeats: true)
//        }

//
//        var currentDate = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//        datestring = dateFormatter.stringFromDate(currentDate)
//        for index in 1...5 {
//            let cal = NSCalendar.currentCalendar()
//            let periodcomponents = NSDateComponents()
//            periodcomponents.month = -index
//            let d = cal.dateByAddingComponents(periodcomponents, toDate: currentDate, options: [])
//            performNASARequest(longitude!, latitude: latitude!, date: dateFormatter.stringFromDate(d!))
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
    
    struct locInfo {
        
        //tiledata properties
        var pic : UIImage
        var url : NSURL
        var date: String
        
    }
    
    func displayImages(){
        if locIndex == nil || locIndex == locHistory.count {
            locIndex = 0
        }
        self.datelabel.text = locHistory[locIndex!]!.date
        self.img.image = locHistory[locIndex!]!.pic
        locIndex!++
    }
    
    func performNASARequestSequence(longitude: String, latitude: String){
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        var datestring = dateFormatter.stringFromDate(currentDate)
        let cal = NSCalendar.currentCalendar()
        let periodcomponents = NSDateComponents()
        var orderIndex = 6
        for index in 0...6 {
//            let cal = NSCalendar.currentCalendar()
//            let periodcomponents = NSDateComponents()
            periodcomponents.month = -index
            let d = cal.dateByAddingComponents(periodcomponents, toDate: currentDate, options: [])
            if let date = d {
                datestring = dateFormatter.stringFromDate(date)
                //print("date being looked up: \(datestring)")
            //self.datelabel.text = datestring
                performNASARequest(longitude, latitude: latitude, date: datestring, order: orderIndex)
                orderIndex--
                //let curloc = locInfo(pic: nil, url: nil, date: datestring)
                //self.locHistory.insert(curloc, atIndex:0)
                
            }
        }
    }
    
    func performNASARequest(longitude: String, latitude: String, date: String, order: Int) {
        let urlComponents = NSURLComponents(string: baseURL)
        let lonQuery: NSURLQueryItem = NSURLQueryItem(name: "lon", value: longitude)
        let latQuery: NSURLQueryItem = NSURLQueryItem(name: "lat", value: latitude)
        let dateQuery: NSURLQueryItem = NSURLQueryItem(name: "date", value: date)
        let cloudQuery: NSURLQueryItem = NSURLQueryItem(name: "cloud_score", value: "True")
        let  keyQuery: NSURLQueryItem = NSURLQueryItem(name: "api_key", value: apikey)

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
                        //print("current order \(order)")
                        let json = try NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.AllowFragments )
                        print("current order \(order)")
                        guard let dict : NSDictionary = json as? NSDictionary else {
                            print("not a dictionary")
                            return
                        }
                        if let date = dict["date"] as? String, img = dict["url"] as? String{
                            //print("date and image found for date \(date)")
                            //print("datestring after calling request: \(self.datestring)")
                            //print("current order \(order)")
                            self.fetchImage(img, withDate: date, currentCount: order)
                            //print("imageurl: \(self.imageurl)")
                            
                        }  else{
                            print("date and image not found in json string")
                        }
                    } catch {
                        print("json error")
                    }
                }
                
        })
        //print("perform function reached")
        task.resume()
        
    }
    
    
    func fetchImage(urlString: String, withDate: String, currentCount: Int){
        //will load remote image into memory and then display image in imageview

        
        if let url = NSURL(string: urlString){
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                
                if error != nil {
                    print("error with image url")
                }
                else if let d = data {
                    //print("loading image into the picture")
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.datelabel.text = self.datestring!
                        let curloc = locInfo(pic: UIImage(data: d)!, url: url, date: withDate)
                        self.locHistory[currentCount] = curloc
                        //self.locHistory.insert(curloc, atIndex:currentCount-1)
                        self.counter--
                        if self.counter == 0 {
                            self.loadingComplete = true
                            self.actInd.stopAnimating()
                            self.actInd.removeFromSuperview()
                            var timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("displayImages"), userInfo: nil, repeats: true)

                        }
                        //self.img.contentMode = UIViewContentMode.ScaleAspectFit
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
