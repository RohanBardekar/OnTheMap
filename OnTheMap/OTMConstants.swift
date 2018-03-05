//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

extension OTMClient {
    
    struct Constants {
    
        static let SchemeKey = "scheme"
        static let ApiPathKey = "apiPath"
        static let HostKey = "host"
    }
    
    struct AuthConstants {
        
        static let Host = "www.udacity.com"
        static let Scheme = "https"
        static let ApiPath = "/api"
    }
    
    struct AuthMethods {
        static let Session = "/session"
    }
    
    struct SessionParameterKeys {
        
        static let DictionaryKey = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct ParseContants {
       
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let StudentLocation = "/StudentLocation"
        static let Where = "where"
        
        
        static let AppID = ""
        static let AppIDHeaderField = "X-Parse-Application-Id"
        
        static let ApiKey = ""
        static let ApiKeyHeaderField = "X-Parse-REST-API-Key"
    }
    
    
    struct UserContants {
        
        static let Users = "/users"
    }
    
    struct ParseMethods {
       
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParseMethodParams {
       
        static let StudentLocationOrder = "order"
        static let StudentLocationLimit = "limit"
        static let StudentLocationSkip = "skip"
        static let DataLimit = 100
        static let UpdatedAtDesc = "-updatedAt"
    }
    
    struct JSONBodyKeys {
       
        static let dictionaryKey = "udacity"
        static let uniqueKey = "uniqueKey"
        static let userNameKey = "username"
        static let passwordKey = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        
        
    }
    
    struct JSONResponseKeys {
       
        static let account = "account"
        static let userId = "key"
        static let results = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let first_name = "first_name"
        static let last_name = "last_name"
        static let user = "user"
    }
    
    struct Alerts {
        
        static let DismissAlert = "Dismiss"
        static let LoginFailed = "Login failed"
    }
}
