//
//  NetworkStatus.swift
//  triploka
//
//  Created by Jordan Rodrigues Rangel on 6/1/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation
public class NetworkStatus {
    
    class func checkNetworkConnection(){
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            
            var status:Bool = false
            let url = NSURL(string: "http://google.com/")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "HEAD"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
            request.timeoutInterval = 10.0
            
            var response: NSURLResponse?
            
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    status = true
                }
            }
            
            if status {
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
                    
                    DAOCloudTrip.getInstance().readNextInstruction()
                }
            }
            
        }
    }
}