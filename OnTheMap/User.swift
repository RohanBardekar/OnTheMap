//
//  User.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

struct User {
   
    let uniqueKey: String
    let firstName: String
    let lastName: String
}

extension User {
    
    init?(_ parameters: [String: AnyObject]) {
        
        guard let firstName = parameters[OTMClient.JSONResponseKeys.first_name] as? String,
            let lastName = parameters[OTMClient.JSONResponseKeys.last_name] as? String,
            let uniqueKey = parameters[OTMClient.JSONResponseKeys.userId] as? String
            
        else {
            return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.uniqueKey = uniqueKey
    }
}
