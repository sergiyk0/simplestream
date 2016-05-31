//
//  JSONInfoParser.swift
//  Simple stream
//
//  Created by Serhii Shapoval on 5/19/16.
//  Copyright © 2016 Serhii Shapoval. All rights reserved.
//

import Foundation

public class JSONInfoParser {
    public func extractUsedData(fromArray: NSArray) -> NSArray? {
        let resultArray = NSMutableArray(capacity: fromArray.count)
        for dictionary in fromArray {
            let extractedDictionary = NSMutableDictionary()
            extractedDictionary[kThumbnailURLKey] = dictionary[kThumbnailURLKey]
            extractedDictionary[kVideoURLKey] = dictionary[kVideoURLKey]
            extractedDictionary[kUsernameKey] = dictionary[kUsernameKey]
            resultArray.addObject(extractedDictionary)
        }
        return resultArray
    }
}
