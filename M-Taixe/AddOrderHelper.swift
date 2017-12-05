//
//  AddOrderHelper.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/4/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class AddOrderHelper{
    var alert = SCLAlertView()

    
    func loadStartEnd(currentUser: User, routeId: Int)->[RouteDetail]{
        var finish = false
        var routeDetails = [RouteDetail]()
        var soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Place_GetStartEnd>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:RouteId>\(routeId)</tem:RouteId>" +
            "</tem:Place_GetStartEnd>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        var soapAction = "http://tempuri.org/IMobihomeWcf/Place_GetStartEnd"
        var sendPost = SendPostRequest()
        sendPost.sendRequest(soapMessage, soapAction: soapAction) {
            (result, error) in
            if error == nil{
                
                var jsonHelper = JsonHelper()
                routeDetails = jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
            }
            else{
                self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")

            }
            finish = true
        }
        while !finish {
            
            sleep(300)
        }
        return routeDetails
    }

}
