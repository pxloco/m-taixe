//
//  ChangeCarViewController.swift
//  M-Taixe
//
//  Created by M on 1/14/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit

class ChangeCarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var topBarMenu: UIView!
    
    var currentUser = User()
    var buses = [Bus]()
    var tripId = String()
    var alert = SCLAlertView()
    var jsonHelper = JsonHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        getBuses()
    }
    
    // MARK: Init
    
    func initData(tripId: String) {
        self.tripId = tripId
    }
    
    func setUpData() {
        let defaults = UserDefaults.standard
        
        let userName = defaults.value(forKey: "UserName")
        let password = defaults.value(forKey: "Password")
        let displayName = defaults.value(forKey: "FullName")
        let roleType = defaults.value(forKey: "RoleType")
        let companyId = defaults.value(forKey: "CompanyId")
        let AgentId = defaults.value(forKey: "AgentId")
        let userId = defaults.value(forKey: "UserId")
        let userGuid = defaults.value(forKey: "UserGuid")
        
        currentUser.UserName = userName  as! String
        currentUser.Password = password as! String
        currentUser.DisplayName = displayName  as! String
        currentUser.RoleType = Int.init(roleType as! String)!
        currentUser.CompanyId = companyId  as! String
        currentUser.AgentId = AgentId as! String
        currentUser.UserId = userId  as! String
        currentUser.UserGuid = userGuid as! String
        
         AppUtils.addShadowToView(view: topBarMenu, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    // MARK: - User Action
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
    }
    
    // MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busViewCell", for: indexPath) as! CarViewCell
        let data = buses[indexPath.row]
        cell.setDataToView(bus: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeBus(ChangeToBusId: buses[indexPath.row].BusId)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MAKR: Get API
    
    func getBuses() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetBusForChange>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "</tem:Trip_GetBusForChange>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetBusForChange"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.buses = self.jsonHelper.parseBus(data!)
                    self.carTableView.reloadData()
                }
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func changeBus(ChangeToBusId: Int) {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_ChangeBus>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:ChangeToBusId>\(ChangeToBusId)</tem:ChangeToBusId>" +
            "</tem:Trip_ChangeBus>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_ChangeBus"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.buses = self.jsonHelper.parseBus(data!)
                    self.carTableView.reloadData()
                }
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
}
