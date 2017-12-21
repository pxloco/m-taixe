//
//  SchemaViewController.swift
//  M-Taixe
//
//  Created by M on 12/11/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit
import WebKit

class SchemaViewController: UIViewController {

    var currentUser = User()
    var tripId = String()
    var gioXuatBen = ""
    var mapXML = String()
    var alert = SCLAlertView()
    
 
    @IBOutlet weak var schemaWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBottomBar()
        getXMLMapView()
        getStatusBookedByTrip()
    }
    
    // MARK: - Init
    
    func initNavigationBottomBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let listCustomerButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ListIcon"), style: UIBarButtonItemStyle.plain, target: nil, action: #selector(SchemaViewController.btnListCustomerClick(_: )))
        let schemaButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let mapButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SchemaViewController.btnMapClick(_:)))
        schemaButton.tintColor = UIColor(netHex: 0x555555)
        listCustomerButton.tintColor = UIColor(netHex: 0x197DAE)
        
        let items = [flex, listCustomerButton, flex, schemaButton, flex, mapButton, flex]
        self.toolbarItems = items
    }
    
    func btnListCustomerClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnMapClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getXMLMapView () {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Map_GetMapXML>" +
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
            "<tem:TripId>\(self.tripId)</tem:TripId>" +
            "</tem:Map_GetMapXML>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        print(soapMessage)
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Map_GetMapXML"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                
                let datastring = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                let htmlDecoded = AppUtils.HTMLEntityDecode(htmlEncodedString: datastring!)
                print(htmlDecoded)
                self.schemaWebView.loadHTMLString(htmlDecoded, baseURL: nil)
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func getStatusBookedByTrip() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Ticket_GetStatusBookedByTrip>" +
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
            "<tem:TripId>\(self.tripId)</tem:TripId>" +
            "</tem:Ticket_GetStatusBookedByTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        print(soapMessage)
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Ticket_GetStatusBookedByTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                
                let datastring = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
}
