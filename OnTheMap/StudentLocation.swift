//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let objectId: String?
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String?
    let updatedAt: String?
    
}

    extension StudentLocation {
    
    init?(result: [String: AnyObject]) {
        
        guard let firstName = result[OTMClient.JSONResponseKeys.firstName] as? String,
            let lastName = result[OTMClient.JSONResponseKeys.lastName] as? String,
            let mapString = result[OTMClient.JSONResponseKeys.mapString] as? String,
            let mediaURL = result[OTMClient.JSONResponseKeys.mediaURL] as? String,
            let latitude = result[OTMClient.JSONResponseKeys.latitude] as? Double,
            let longitude = result[OTMClient.JSONResponseKeys.longitude] as? Double,
            let createdAt = result[OTMClient.JSONResponseKeys.createdAt] as? String,
            let updatedAt = result[OTMClient.JSONResponseKeys.updatedAt] as? String,
            let objectId = result[OTMClient.JSONResponseKeys.objectId] as? String,
            let uniqueKey = result[OTMClient.JSONResponseKeys.uniqueKey] as? String
           
        else {
            return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.objectId = objectId
        self.uniqueKey = uniqueKey
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = nil
        self.uniqueKey = uniqueKey
        self.updatedAt = nil
        self.objectId = nil
    }
    
    static func getStudentsLocations(json: [String: AnyObject]) -> [StudentLocation] {
        
        var studentLocations: [StudentLocation] = []
        
        for case let result in json[OTMClient.JSONResponseKeys.results] as! [AnyObject]{
           
            if let studentLocation = StudentLocation(result: result as! [String: AnyObject]) {
                
                studentLocations.append(studentLocation)
            }
        }
       
        return studentLocations
    
    }
    
    }

    struct StudentLocationCollection {
   
    static var studentLocations = [StudentLocation]()
    
    static func addStudentLocations(json: [String: AnyObject]) -> Void {
        
        studentLocations.removeAll()
    
        for case let result in json[OTMClient.JSONResponseKeys.results] as! [AnyObject]{
        
            if let studentLocation = StudentLocation(result: result as! [String: AnyObject]) {
            
                studentLocations.append(studentLocation)
            }
        }
    }
    
    static var all: [StudentLocation] {
       
        return studentLocations
    }
    
    static func get(atIndex index: Int) -> StudentLocation {
        
        return studentLocations[index]
    }
    
    static var count: Int {
        
        return studentLocations.count
        
        }
    }
