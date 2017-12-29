//
//  SchemaApi.swift
//  M-Taixe
//
//  Created by M on 12/25/17.
//  Copyright © 2017 kha. All rights reserved.
//

import Foundation

class SchemaApi {
    
    class func Ticket_CheckExistsV2(TripId: String, SeatId: String, DepartGuid: String, ArrivalGuid: String) -> String {
        let sendPostRequest = SendPostRequest()
        var datastring = String()
        var alert = SCLAlertView()
        let soapAction = "http://tempuri.org/IMobihomeWcf/Ticket_CheckExistsV2"
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Ticket_CheckExistsV2>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(UserDefaults.standard.value(forKey: "CompanyId")!)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(UserDefaults.standard.value(forKey: "AgentId")!)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(UserDefaults.standard.value(forKey: "UserName")!)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(UserDefaults.standard.value(forKey: "Password")!)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(TripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:SeatId>\(SeatId)</tem:SeatId>" +
            "<!--Optional:-->" +
            "<tem:DepartGuid>\(DepartGuid)</tem:DepartGuid>" +
            "<!--Optional:-->" +
            "<tem:ArrivalGuid>\(ArrivalGuid)</tem:ArrivalGuid>" +
            "<!--Optional:-->" +
            "<tem:DeviceId>\(UserDefaults.standard.string(forKey: "DevideId")!)</tem:DeviceId>" +
            "<!--Optional:-->" +
            "<tem:SessionId>\(UserDefaults.standard.string(forKey: "SessionId")!)</tem:SessionId>" +
            "</tem:Ticket_CheckExistsV2>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                
                datastring = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            }
            else {
                alert.hideView()
                alert = SCLAlertView()
                alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
        return datastring
    }
    
    class func getStatusBookedByTrip(tripId: String) -> Data {
        let sendPostRequest = SendPostRequest()
        var dataString = Data()
        var alert = SCLAlertView()
        let soapAction = "http://tempuri.org/IMobihomeWcf/Ticket_GetStatusBookedByTrip"
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Ticket_GetStatusBookedByTrip>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(UserDefaults.standard.value(forKey: "CompanyId")!)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(UserDefaults.standard.value(forKey: "AgentId")!)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(UserDefaults.standard.value(forKey: "UserName")!)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(UserDefaults.standard.value(forKey: "Password")!)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "</tem:Ticket_GetStatusBookedByTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                dataString = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            }
            else {
                alert.hideView()
                alert = SCLAlertView()
                alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
        
        return dataString
    }
    
    class func Map_GetMapXML(tripId: String) -> String {
        var dataString = String()
        var alert = SCLAlertView()
        let soapAction = "http://tempuri.org/IMobihomeWcf/Map_GetMapXML"
        let sendPostRequest = SendPostRequest()
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Map_GetMapXML>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(UserDefaults.standard.value(forKey: "CompanyId")!)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(UserDefaults.standard.value(forKey: "AgentId")!)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(UserDefaults.standard.value(forKey: "UserName")!)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(UserDefaults.standard.value(forKey: "Password")!)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "</tem:Map_GetMapXML>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        DispatchQueue.main.async {
            sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
                if error == nil {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    
                    dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    dataString = AppUtils.HTMLEntityDecode(htmlEncodedString: dataString)
                }
                else {
                    alert.hideView()
                    alert = SCLAlertView()
                    alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
                }
            }
        }
        
        return dataString
    }
    
    class func replaceHtmlWithJavascrip(htmlDecoded: String) -> String {
        var map = htmlDecoded.replacingOccurrences(of: "<svg", with: "<svg id='msvg'")
        let javascriptFile = AppUtils.scriptSeat()
        map = map.replacingOccurrences(of: "</svg>", with: "<image id='imgCheck' transform=\"translate(190.5113067626953 49.46282958984375)\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xlink:href=\"http://mobihome.vn/Data/style/site/images/icon/tick_black.png\" isstatus=\"1\" seatid=\"876\" sold=\"1\" width=\"13\" height=\"13\" visibility=\"visible\"></image>\n" +
        "<path id='imgChoose' d=\"m110.81644,98.29003c0,0 4.70955,3.78324 5.65144,5.32866l4.05022,0c1.69544,-3.69561 8.28878,-12.51835 13.94022,-15.60929c1.17099,-1.07400 -1.77050,-1.51728 -4.14439,-0.80630c-3.57765,1.07151 -10.32511,9.25255 -11.58549,11.22123c-1.78961,0.33593 -3.67344,-2.15019 -3.67344,-2.15019l-4.23861,2.01594z\" fill=\"#000\" fill-rule=\"evenodd\" stroke-width=\"1px\" ischeckforticket=\"1\" seatid=\"875\"></path>\n</svg>");
        map = "<html><head>\n" +
        "<meta charset=\"UTF-8\">\n" +
        "<meta name=\"description\" content=\"Free Web tutorials\">\n" +
        "<meta name=\"keywords\" content=\"HTML,CSS,XML,JavaScript\">\n" +
        "<meta name=\"author\" content=\"Hege Refsnes\">\n" +
        "</head><body>" + map
        map += javascriptFile + "</body></html>"
        
        return map
    }
}
