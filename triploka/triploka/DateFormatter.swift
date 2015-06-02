//
//  DateFormatter.swift
//  triploka
//
//  Created by Jordan Rodrigues Rangel on 6/2/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import Foundation

class DateFormatter {
    
    class func formattedDate(date: NSDate) -> String {
        
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateTimePrefix: String = formatter.stringFromDate(NSDate())
        
        return dateTimePrefix
    }
}