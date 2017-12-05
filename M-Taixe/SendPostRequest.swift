//
//  SendPostRequest.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/16/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class SendPostRequest: NSObject{
    public typealias SendPostRequestCallBack = (_ string: String, _ error: NSError?) -> Void
    private var callBack : SendPostRequestCallBack?
    var error: NSError?
    func sendRequest(_ soapMessage: String, soapAction: String, callBack: @escaping SendPostRequestCallBack){
        let urlString = "http://api.mobihome.vn/Mobihome.svc"
        let url = URL(string: urlString)
        let theRequest = NSMutableURLRequest.init(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 3)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.addValue("api.mobihome.vn", forHTTPHeaderField: "Host")
        theRequest.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        theRequest.addValue(soapAction, forHTTPHeaderField: "SOAPAction")
        theRequest.addValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        NSURLConnection.sendAsynchronousRequest(theRequest as URLRequest, queue: OperationQueue.main) { (response, data, error) in
            self.error = error as NSError?
            self.callBack = callBack
            if error == nil {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    let s = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    switch (soapAction){
                    case "http://tempuri.org/IMobihomeWcf/Order_GetByTrip":
                        self.parseOrder(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/TripDriver_GetByDate":
                        self.parseDriver_tripByDate(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Trip_GetForBooking":
                        self.parseTripByRoute(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Trip_GetOne":
                        self.parseOneTrip(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/UpdateOnBus":
                        callBack("", error as NSError?)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/SiteLogInV2":
                        self.parseLogin(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Route_GetForBooking":
                        self.parseRoutes(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Place_GetStartEnd":
                        self.parseStartEnd(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Place_SearchDepart":
                        self.parseDeparts(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Place_SearchArrival":
                        self.parseArrivals(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Calling_GetListRecent":
                        self.parseRecentCall(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Calling_Filter":
                        self.parseFilterCall(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/GetBillOnTrip":
                        self.parseBills(s: s!, callBack: callBack)
                        break;
                    case "http://tempuri.org/IMobihomeWcf/Order_FastSearch":
                        self.parseSearch(s: s!, callBack: callBack)
                        break;
                    default:
                        callBack("", error as NSError?)
                        break;
                    }
                    
                }
                else{
                    callBack("", error as NSError?)
                }
            }
            else{
                callBack("", error as NSError?)
            }
            
        }
    }
    func parseSearch(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Order_FastSearchResult")
        if arr.count > 0{
            let result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    
    func parseBills(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "GetBillOnTripResult")
        if arr.count > 0{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            result = result.components(separatedBy: "\"listing\":")[1].replacingOccurrences(of: "}]}]", with: "}]")
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    
    func parseFilterCall(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Calling_FilterResult")
        if arr.count > 0{
            let result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    func parseRecentCall(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Calling_GetListRecentResult")
        if arr.count > 0{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    
    func parseArrivals(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Place_SearchArrivalResult")
        if arr.count > 0{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    
    func parseDeparts(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Place_SearchDepartResult")
        if arr.count > 2{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    
    func parseStartEnd(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Place_GetStartEndResult")
        if arr.count > 0{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    func parseRoutes(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Route_GetForBookingResult")
        if arr.count > 0{
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
        }
        else{
            callBack("", NSError())
        }
    }
    func parseLogin(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "SiteLogInV2Result")
        
        var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
        
        if result == "true"{
            arr = s.components(separatedBy: "DisplayName")
            var displayName = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            arr = s.components(separatedBy: "RoleTye")
            var roleType = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            arr = s.components(separatedBy: "CompanyId")
            var companyId = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            arr = s.components(separatedBy: "AgentId")
            var agentId = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            arr = s.components(separatedBy: "UserId")
            var userId = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            
            arr = s.components(separatedBy: "UserGuid")
            var userGuid = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            result+="\t\(displayName)\t\(roleType)\t\(companyId)\t\(agentId)\t\(userId)\t\(userGuid)"
        }
        callBack(result, error as NSError?)
    }
    func parseDriver_tripByDate(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: CharacterSet(charactersIn: ">"))
        for i in 0 ... arr.count - 1{
            arr[i] = arr[i].replacingOccurrences(of: "</TripDriver_GetByDateResult", with: "")
            if arr[i].contains("<") == false && arr[i].contains(">") == false{
                
                callBack(arr[i] as String, nil)
                break
            }
            
        }
    }
    func parseOneTrip(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Trip_GetOneResult")
        if arr.count > 2 {
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
            
        }
        else{
            callBack("", nil)
        }
    }
    
    func parseTripByRoute(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: "Trip_GetForBookingResult")
        if arr.count > 2 {
            var result = arr[1].replacingOccurrences(of: ">", with: "").replacingOccurrences(of: "</", with: "") ?? ""
            callBack(result, nil)
            
        }
        else{
            callBack("", nil)
        }
    }
    func parseOrder(s: NSString,callBack: @escaping SendPostRequestCallBack){
        var arr = s.components(separatedBy: CharacterSet(charactersIn: ">"))
        for i in 0...arr.count-1 {
            arr[i] = arr[i].replacingOccurrences(of: "</Order_GetByTripResult", with: "")
            if arr[i].contains("<") == false && arr[i].contains(">") == false{
                callBack(arr[i], error as NSError?)
                break
            }
            
        }
        
    }
    var resultLogin = ""
    var loginCount = 0
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if loginCount == 1{
            resultLogin = "\(resultLogin)\(string)"
            print(resultLogin)
            self.callBack!(resultLogin, self.error)
        }
        else{
            if string != "false"{
                resultLogin = "\(string)\t"
                
            }
            else{
                self.callBack!(string, self.error)
                return
                
            }
        }
        loginCount += 1
        //print(string)
    }
    
}