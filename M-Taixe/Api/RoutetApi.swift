//
//  RootApi.swift
//  M-Taixe
//
//  Created by M on 1/1/18.
//  Copyright © 2018 kha. All rights reserved.
//

import Foundation

class RouteApi {
    
//    class func Trip_GetBusList(companyId: String, AgentId: String, UserName: String, Password: String) -> Data {
//        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
//            "<soapenv:Header/>" +
//            "<soapenv:Body>" +
//            "<tem:Trip_GetBusList>" +
//            "<!--Optional:-->" +
//            "<tem:CompanyId>\(companyId)</tem:CompanyId>" +
//            "<!--Optional:-->" +
//            "<tem:AgentId>\(AgentId)</tem:AgentId>" +
//            "<!--Optional:-->" +
//            "<tem:UserName>\(UserName)</tem:UserName>" +
//            "<!--Optional:-->" +
//            "<tem:Password>\(Password)</tem:Password>" +
//            "<!--Optional:-->" +
//            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
//            "</tem:Trip_GetBusList>" +
//            "</soapenv:Body>" +
//        "</soapenv:Envelope>"
//        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetBusList"
//        var data = Data()
//        let sendPostRequest = SendPostRequest()
//        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
//            if error == nil {
//                return data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//            }
//        }
//    }
}
