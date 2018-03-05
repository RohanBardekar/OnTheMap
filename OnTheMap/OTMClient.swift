//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
   
    var urlSession = URLSession.shared
    var onTheMap: OnTheMap!
    var user: User!
    
    override init() {
        
        super.init()
    }
    
    func taskOnParseGetRequest(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], getReqestCompletionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForParse(urlComponents, queryParams, method)
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
             
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                getReqestCompletionHandler(nil, NSError(domain: "taskOnParseGetRequest", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                
                sendError("Error during request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 &&
                
                statusCode <= 299 else {
                
                    sendError("Request returned response other than 2xx")
                    return
            }
            
            guard data != nil else {
                
                sendError("No data returned from request")
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForDataConversion: getReqestCompletionHandler)
        }
        
        task.resume()
        return task
    }
    
    func taskOnParsePostRequest(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], _ jsonBody: String, completionHandlerForPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForParse(urlComponents, queryParams, method)
        request.httpMethod = "POST"
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
               
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskOnParsePostRequest", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                
                sendError("Error during request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Request returned response other than 2xx")
                    return
            }
            
            guard data != nil else {
                
                sendError("No data returned from request")
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForDataConversion: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    
    private func getRequestForParse(_ urlComponents: [String: AnyObject], _ queryParams: [String: AnyObject], _ method: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: self.urlFromParameters(urlComponents, queryParams, withPathExtension: method))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(OTMClient.ParseContants.ApiKey, forHTTPHeaderField: OTMClient.ParseContants.ApiKeyHeaderField)
        request.addValue(OTMClient.ParseContants.AppID, forHTTPHeaderField: OTMClient.ParseContants.AppIDHeaderField)
        return request
    }
    
    
    func taskForGetMethod(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject],getReqestCompletionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
            
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                getReqestCompletionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                
                sendError("Error during request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Request returned response other than 2xx")
                return
            }
            
            guard data != nil else {
                
                sendError("No data returned from request")
                return
            }
            
            let newData = self.getUdacityData(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: getReqestCompletionHandler)
        }
        
        task.resume()
        return task
        
    }
    
    
    func taskOnPostRequest(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        request.httpMethod = "POST"
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, _ statusCode: Int) {
                
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskOnPostRequest", code: statusCode, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                
                sendError("Error during request: \(error!)", 1)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                sendError("Request returned response other than 2xx", ((response as? HTTPURLResponse)?.statusCode)!)
                return
            }
            
            guard data != nil else {
                
                sendError("No data returned from request", 1)
                return
            }
            
            let newData = self.getUdacityData(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    
    func taskOnDeleteRequest(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], headerParameters: [String: AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        request.httpMethod = "DELETE"
        
        for (k, v) in headerParameters {
            request.setValue(k as String, forHTTPHeaderField: v as! String)
        }
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETE(nil, NSError(domain: "taskOnDeleteRequest", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
                sendError("Error during request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 &&
                statusCode <= 299 else {
                    sendError("Request returned response other than 2xx")
                    return
            }
            
            guard data != nil else {
                sendError("No data returned from request")
                return
            }
            
            let newData = self.getUdacityData(data)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: completionHandlerForDELETE)
        }
        
        task.resume()
        
        return task
        
    }
    
    
    private func getRequestForUdacity(_ urlComponents: [String: AnyObject], _ queryParams: [String: AnyObject], _ method: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: self.urlFromParameters(urlComponents, queryParams, withPathExtension: method))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    
    private func getUdacityData(_ data: Data?) -> Data {
        
        // Remove the first 5 characters of response from Udacity
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range)
        return newData!
    }
    
    private func urlFromParameters(_ urlComponents: [String: AnyObject], _ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = urlComponents[OTMClient.Constants.SchemeKey] as? String
        components.host = urlComponents[OTMClient.Constants.HostKey] as? String
        components.path = urlComponents[OTMClient.Constants.ApiPathKey] as! String + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for(key, value)  in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForDataConversion: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }
        catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Couldn't parse data as JSON: '\(data)'"]
            completionHandlerForDataConversion(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForDataConversion(parsedResult, nil)
    }
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
        
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
