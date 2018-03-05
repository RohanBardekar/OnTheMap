//
//  OnTheMap.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

struct OnTheMap {
    let account: [String: AnyObject]
    
    
    init(_ dictionary: [String: AnyObject]) {
        account = dictionary[OTMClient.JSONResponseKeys.account] as! [String : AnyObject]
    }
    
    func getUserId() -> String {
        return (account[OTMClient.JSONResponseKeys.userId] as? String)!
    }
    
}
