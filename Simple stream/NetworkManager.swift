//
//  NetworkManager.swift
//  Simple stream
//
//  Created by Serhii Shapoval on 5/17/16.
//  Copyright © 2016 Serhii Shapoval. All rights reserved.
//

import UIKit

let getContentUrl = NSURL(string: kGetVideoListURLString)!

public class NetworkManager {
    let session = NSURLSession.sharedSession()
    
    public func getVideoList(handler completionHandler: (results: NSArray?, error: NSError?) -> Void) {
        let getVideoListDataTask = session.dataTaskWithURL(getContentUrl) { (responseData, _, requestError) in
            if nil != responseData && nil == requestError {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    let dataArray = json[kDataKey]![kRecordsKey] as? NSArray
                    completionHandler(results: dataArray, error: requestError)
                } catch {
                    print(error)
                }
            } else {
                completionHandler(results: nil, error: requestError)
            }
        }
        getVideoListDataTask.resume()
    }
    
    public func getThumbnail(sourceUrlString: String, completionHandler: (resultImage: UIImage?, error: NSError?) -> Void) {
        let thumbnailDataTask = session.dataTaskWithURL(NSURL(string: sourceUrlString)!) { (responseData, _, requestError) in
            if nil != responseData {
                let thumbnail = UIImage(data: responseData!)
                completionHandler(resultImage: thumbnail, error: nil)
            } else {
                completionHandler(resultImage: nil, error: requestError)
            }
        }
        thumbnailDataTask.resume()
    }
}
