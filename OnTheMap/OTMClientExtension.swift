//
//  OTMClientExtension.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
   
    func authenticateWithViewController(_ hostViewController: UIViewController, _ userName: String, _ password: String, authCompletionHandler: @escaping (_ sucess: Bool, _ errorString: String?) -> Void) {
        
        getSession(userName, password) { (success, onTheMap, errorString) in
            
        if success {
            
            if let onTheMap = onTheMap {
                
                print(onTheMap.getUserId())
                self.onTheMap = onTheMap
            }
                
            self.getLoginUserDetails() { (success, results, errorString) in
            
                if success {
                    
                    if let results = results {
                        
                        let user = results["\(JSONResponseKeys.user)"] as! [String: AnyObject]
                        self.user = User(user)
                    }
                }
            }
            }
            
            authCompletionHandler(success, errorString)
        }
    }
    
    func logoutWithViewController(_ hostViewController: UIViewController, logoutCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        deleteSession() { (success, errorString) in
            
            if success {
                
                print(success)
                self.onTheMap = nil
            }
            
            logoutCompletionHandler(success, errorString)
        }
    }
    
    func getStudentLocations(_ hostViewController: UIViewController, getStudentLocationCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getStudentLocations() { (success, results, errorString) in
            
            if success {
                
                StudentLocationCollection.addStudentLocations(json: results as! [String : AnyObject])
            }
            else {
                
                print("Failed to fetch StudentLocations")
            }
            
            getStudentLocationCompletionHandler(success, errorString)
        }
    }
    
    func postStudentLocation(_ studentLocation: StudentLocation, postStudentLocationCompletionHander: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postStudentLocation(studentLocation) { (success, results, errorString) in
            
            if success {
                
                print("Successfully posted student location")
            }
            else {
                
                print("post failed")
            }
            
            postStudentLocationCompletionHander(success, errorString)
        }
    }
    
    private func getSession(_ userName: String, _ password: String, getSessionCompletionHandler: @escaping (_ success: Bool, _ ontheMap: OnTheMap?, _ errorString: String?) -> Void) {
        
        var urlComponents = [String: AnyObject]()
        urlComponents["\(OTMClient.Constants.SchemeKey)"] = OTMClient.AuthConstants.Scheme as AnyObject
        urlComponents["\(OTMClient.Constants.HostKey)"] = OTMClient.AuthConstants.Host as AnyObject
        urlComponents["\(OTMClient.Constants.ApiPathKey)"] = OTMClient.AuthConstants.ApiPath as AnyObject
        
        let jsonRequestBody = "{\"\(OTMClient.JSONBodyKeys.dictionaryKey)\": {\"\(OTMClient.JSONBodyKeys.userNameKey)\": \"\(userName)\", \"\(OTMClient.JSONBodyKeys.passwordKey)\": \"\(password)\"}}"
        
        let _ = OTMClient.sharedInstance().taskOnPostRequest(OTMClient.AuthMethods.Session, urlComponents: urlComponents, queryParams: [String: AnyObject](), jsonBody: jsonRequestBody) { (results, error) in
            
            if let error = error {
               
                print(error)
                if error.code == 403 {
                    
                    getSessionCompletionHandler(false, nil, "Login failed for the User:\(userName). Check email id and password")
                }
                else {
                    
                    getSessionCompletionHandler(false, nil, "The internet connection is offline, please try again")
                }
            }
            else {
                
                let ontheMap = OnTheMap(results as! [String : AnyObject])
                getSessionCompletionHandler(true, ontheMap, nil)
            }
        }
    }
    
    private func deleteSession(deleteSessionCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var headerParameters = [String: AnyObject]()
        if let xsrfCookie = xsrfCookie {
            
            headerParameters[xsrfCookie.value] = "X-XSRF-TOKEN" as AnyObject
        }
        
        var urlComponents = [String: AnyObject]()
        urlComponents["\(OTMClient.Constants.SchemeKey)"] = OTMClient.AuthConstants.Scheme as AnyObject
        urlComponents["\(OTMClient.Constants.HostKey)"] = OTMClient.AuthConstants.Host as AnyObject
        urlComponents["\(OTMClient.Constants.ApiPathKey)"] = OTMClient.AuthConstants.ApiPath as AnyObject
        
        let _ = OTMClient.sharedInstance().taskOnDeleteRequest(OTMClient.AuthMethods.Session, urlComponents: urlComponents, queryParams: [String: AnyObject](), headerParameters: headerParameters) { (results, error) in
            
            if let error = error {
                
                print(error)
                deleteSessionCompletionHandler(false, "Logout failed")
            }
            else {
                
                deleteSessionCompletionHandler(true, nil)
            }
            
        }
    }
    
    private func getStudentLocations(getStudentLocationCompletionHandler: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void) {
        
        var urlComponents = [String: AnyObject]()
        urlComponents["\(OTMClient.Constants.SchemeKey)"] = OTMClient.ParseContants.Scheme as AnyObject
        urlComponents["\(OTMClient.Constants.HostKey)"] = OTMClient.ParseContants.Host as AnyObject
        urlComponents["\(OTMClient.Constants.ApiPathKey)"] = OTMClient.ParseContants.ApiPath as AnyObject
        var queryParams = [String: AnyObject]()
        queryParams[OTMClient.ParseMethodParams.StudentLocationLimit] = OTMClient.ParseMethodParams.DataLimit as AnyObject
        queryParams[OTMClient.ParseMethodParams.StudentLocationOrder] = OTMClient.ParseMethodParams.UpdatedAtDesc as AnyObject
        
        
        let _ = OTMClient.sharedInstance().taskOnParseGetRequest(OTMClient.ParseMethods.StudentLocation, urlComponents: urlComponents, queryParams: queryParams) { (results, error) in
            
            if let error = error {
                
                print(error)
                getStudentLocationCompletionHandler(false, nil, "Failed to Get Student Locations")
            }
            else {
              
                getStudentLocationCompletionHandler(true, results, nil)
            }
        }
    }
    
    private func getLoginUserDetails(loginDetailsCompletionHandler: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void) {
        
        var urlComponents = [String: AnyObject]()
        urlComponents[OTMClient.Constants.SchemeKey] = OTMClient.AuthConstants.Scheme as AnyObject
        urlComponents[OTMClient.Constants.HostKey] = OTMClient.AuthConstants.Host as AnyObject
        urlComponents[OTMClient.Constants.ApiPathKey] = OTMClient.AuthConstants.ApiPath as AnyObject
        
        let uniqueKey = OTMClient.sharedInstance().onTheMap.getUserId()
        let method = "\(OTMClient.UserContants.Users)/\(uniqueKey)"
        
        let _ = OTMClient.sharedInstance().taskForGetMethod(method, urlComponents: urlComponents, queryParams: [String: AnyObject]()) { (results, error) in
            
            if let error = error {
               
                print(error)
                loginDetailsCompletionHandler(false, nil, "Failed to get user information")
            }
            else {
                
                loginDetailsCompletionHandler(true, results, nil)
            }
            
        }
    }
    
    private func postStudentLocation(_ studentLocation: StudentLocation, postStudentLocationCompletionHandler: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void ){
        
        var urlComponents = [String: AnyObject]()
        urlComponents[OTMClient.Constants.SchemeKey] = OTMClient.ParseContants.Scheme as AnyObject
        urlComponents[OTMClient.Constants.HostKey] = OTMClient.ParseContants.Host as AnyObject
        urlComponents[OTMClient.Constants.ApiPathKey] = OTMClient.ParseContants.ApiPath as AnyObject
        
        let jsonRequestBody = "{\"\(OTMClient.JSONBodyKeys.uniqueKey)\": \"\(studentLocation.uniqueKey)\", \"\(OTMClient.JSONBodyKeys.firstName)\": \"\(studentLocation.firstName)\", \"\(OTMClient.JSONBodyKeys.lastName)\": \"\(studentLocation.lastName)\", \"\(OTMClient.JSONBodyKeys.mapString)\": \"\(studentLocation.mapString)\", \"\(OTMClient.JSONBodyKeys.mediaURL)\": \"\(studentLocation.mediaURL)\", \"\(OTMClient.JSONBodyKeys.latitude)\": \(studentLocation.latitude), \"\(OTMClient.JSONBodyKeys.longitude)\": \(studentLocation.longitude)}"
        
        print(jsonRequestBody)
        
        let _ = OTMClient.sharedInstance().taskOnParsePostRequest(OTMClient.ParseMethods.StudentLocation, urlComponents: urlComponents, queryParams: [String: AnyObject](), jsonRequestBody) { (results, error) in
            
            if let error = error {
               
                print(error)
                postStudentLocationCompletionHandler(false, nil, "Failed to Post Student Location")
            }else {
                
                postStudentLocationCompletionHandler(true, results, nil)
            }
        }
    }
}

