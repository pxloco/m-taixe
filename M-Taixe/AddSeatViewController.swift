//
//  AddSeatViewController.swift
//  M-Taixe
//
//  Created by M on 1/29/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import HPUIViewExtensions

class AddSeatViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var countPhoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameUserTextField: UITextField!
    @IBOutlet weak var departWebView: UIWebView!
    @IBOutlet weak var arrivalWebView: UIWebView!
    @IBOutlet weak var paidCheckBox: UICheckbox!
    @IBOutlet weak var catchTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var avoidingView: HPView!
    
    var arrSeat = [String]()
    var tripId = String()
    var currentTrip = Trip()
    var currentUser = User()
    var alert = SCLAlertView()
    var routeId = Int()
    var departs = [RouteDetail]()
    var arrivals = [RouteDetail]()
    var htmlString = ""
    var helper = AddOrderHelper()
    var sendPostRequest = SendPostRequest()
    var jsonHelper = JsonHelper()
    var orderGuid = "00000000-0000-0000-0000-000000000000"
    var currentOrder = Customer()
    var seats = ""
    var ticket = Ticket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        self.hideKeyboardWhenTappedAround()
        KeyboardAvoiding.avoidingView = self.avoidingView
    }
    
    // MARK: Init data
    
    func initDataFromShema(tripId: String, currentUser: User, currentTrip: Trip, ticket: Ticket, seatInOrder: String) {
        self.tripId = tripId
        self.currentUser = currentUser
        self.currentTrip = currentTrip
        self.orderGuid = ticket.OrderGuid
        self.ticket = ticket
        self.seats = seatInOrder
    }
    
    func initData() {
        alert.showWait("Đang tải dữ liệu", subTitle: "Vui lòng đợi")
        self.navigationItem.title = "Thêm vé"
        if self.tripId != "" {
            loadOneTrip()
        }

        if orderGuid != "00000000-0000-0000-0000-000000000000" {
            titleLabel.text = "Sửa vé"
            arrSeat = currentOrder.SeatInOrder.components(separatedBy: ",")
            phoneTextField.text = ticket.TicketCustMobile
            nameUserTextField.text = ticket.TicketCustName
            
            if ticket.PaidTime != 0 {
                paidCheckBox.isSelected = true
            }
            catchTextField.text = ticket.CatchAddress
        }
        
        let bundle = Bundle.main
        let file = bundle.path(forResource: "select", ofType: "html")
        do {
            htmlString = try String.init(contentsOfFile: file!)
        }
        catch {
            
        }

        for seat in arrSeat {
            self.seats = "\(seats),\(seat)"
        }
        
        titleLabel.text = "Ghế số: \(seats)"
    }
    
    
    // MARK: User Action
    
    @IBAction func closeAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookTicketAction(_ sender: Any) {
        saveOrder()
    }
    
    @IBAction func addPhoneAction(_ sender: Any) {
    }
    
    @IBAction func printTicketAction(_ sender: Any) {
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        KeyboardAvoiding.avoidingView = self.avoidingView
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Helpper
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.orderGuid != "00000000-0000-0000-0000-000000000000" {
            print(self.currentOrder.ArrivalText)
            for i in 0..<departs.count{
                if departs[i].StopPointId == self.currentOrder.DepartGuid{
                    self.departWebView.stringByEvaluatingJavaScript(from: "document.getElementById('select').selectedIndex=\(i)")
                }
            }
            for i in 0..<arrivals.count{
                if arrivals[i].StopPointId == self.currentOrder.ArrivalGuid{
                    self.arrivalWebView.stringByEvaluatingJavaScript(from: "document.getElementById('select').selectedIndex=\(i)")
                }
            }
        }
    }
    
    func parseRouteDetailsToString(routeDetails: [RouteDetail])->String{
        var result = ""
        for routeDetail in routeDetails{
            result = "\(result)<option value=\"\(routeDetail.StopPointId)\">\(routeDetail.Name)</option>"
        }
        return result
    }
    
    // Mark: Load Data
    
    func loadDeparts(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Place_SearchDepart>" +
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
            "<tem:RouteId>\(currentTrip.RouteId)</tem:RouteId>" +
            "<!--Optional:-->" +
            "<tem:SearchText></tem:SearchText>" +
            "</tem:Place_SearchDepart>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchDepart"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if result != ""{
                let dps = self.jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                self.departs.append(contentsOf: dps)
                
            }
            self.loadArrivals()
            
        }
    }
    
    func loadArrivals(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Place_SearchArrival>" +
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
            "<tem:RouteId>\(currentTrip.RouteId)</tem:RouteId>" +
            "<!--Optional:-->" +
            "<tem:SearchText></tem:SearchText>" +
            "</tem:Place_SearchArrival>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchArrival"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if result != ""{
                let arrs = self.jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                self.arrivals.append(contentsOf: arrs)
                self.bindSelectData()
            }
        }
    }
    
    func bindSelectData() {
        DispatchQueue.main.async {
            var departsStr = self.parseRouteDetailsToString(routeDetails: self.departs)
            var arrivalStr = self.parseRouteDetailsToString(routeDetails: self.arrivals)
            departsStr = self.htmlString.replacingOccurrences(of: "optionvalue", with: departsStr)
            arrivalStr = self.htmlString.replacingOccurrences(of: "optionvalue", with: arrivalStr)
            self.departWebView.loadHTMLString(departsStr, baseURL: nil)
            self.arrivalWebView.loadHTMLString(arrivalStr, baseURL: nil)
            self.alert.hideView()
        }
    }
    
    func loadOneTrip(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetOne>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Trip_GetOne>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetOne"
        
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            
            if error == nil{
                let text = "[\(result)]"
                let jsonHelper = JsonHelper()
                var trips = jsonHelper.parseTrips(text.data(using: String.Encoding.utf8)!)
                self.currentTrip = trips[0]
                if self.currentTrip.RouteId > 0{
                    self.loadStartEnd()
                }
                else{
                    self.alert.hideView()
                    self.alert = SCLAlertView()
                    self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")
            }
        }
    }
    
    func loadStartEnd(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
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
            "<tem:RouteId>\(self.currentTrip.RouteId)</tem:RouteId>" +
            "</tem:Place_GetStartEnd>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_GetStartEnd"
        let sendPost = SendPostRequest()
        sendPost.sendRequest(soapMessage, soapAction: soapAction) {
            (result, error) in
            if error == nil{
                
                let jsonHelper = JsonHelper()
                let startEnd = jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                for detail in startEnd {
                    if detail.IsStartPoint{
                        self.departs.append(detail)
                    }
                    else{
                        self.arrivals.append(detail)
                    }
                }
                self.loadDeparts()
            } else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")
            }
        }
    }
    
    func saveOrder(){
        let custMobile = phoneTextField.text ?? ""
        let custName = nameUserTextField.text ?? ""
        let catchAdd = catchTextField.text ?? ""
        let departGuid = departWebView.stringByEvaluatingJavaScript(from: "document.getElementById('select').value") ?? ""
        let arrivalGuid = arrivalWebView.stringByEvaluatingJavaScript(from: "document.getElementById('select').value") ?? ""
        let departText = departWebView.stringByEvaluatingJavaScript(from: "getSelectedText()") ?? ""
        let arrivalText = arrivalWebView.stringByEvaluatingJavaScript(from: "getSelectedText()") ?? ""
        let paid = paidCheckBox.isSelected
        
       
        if custMobile == ""{
            self.alert.showError("Lỗi!", subTitle: "Bạn phải điền số điện thoại của khách!")
            return
        }
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Order_SaveV2>" +
            "<!--Optional:-->" +
            "<tem:OrderGuid>\(orderGuid)</tem:OrderGuid>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(currentTrip.TripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:CustName>\(custName)</tem:CustName>" +
            "<!--Optional:-->" +
            "<tem:CustMobile>\(custMobile)</tem:CustMobile>" +
            "<!--Optional:-->" +
            "<tem:DepartGuid>\(departGuid)</tem:DepartGuid>" +
            "<!--Optional:-->" +
            "<tem:DepartText>\(departText)</tem:DepartText>" +
            "<!--Optional:-->" +
            "<tem:ArrivalGuid>\(arrivalGuid)</tem:ArrivalGuid>" +
            "<!--Optional:-->" +
            "<tem:ArrivalText>\(arrivalText)</tem:ArrivalText>" +
            "<!--Optional:-->" +
            "<tem:AddressId>0</tem:AddressId>" +
            "<!--Optional:-->" +
            "<tem:CatchAddress>\(catchAdd)</tem:CatchAddress>" +
            "<!--Optional:-->" +
            "<tem:DropAddressId>0</tem:DropAddressId>" +
            "<!--Optional:-->" +
            "<tem:DropAddress></tem:DropAddress>" +
            "<!--Optional:-->" +
            "<tem:CatchType>3</tem:CatchType>" +
            "<!--Optional:-->" +
            "<tem:IsPaid>\(paid)</tem:IsPaid>" +
            "<!--Optional:-->" +
            "<tem:SeatNumbers>\(seats)</tem:SeatNumbers>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserGuid>\(currentUser.UserGuid)</tem:UserGuid>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:Mobile>0</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:SessionId>\(UserDefaults.standard.value(forKey: "SessionId")!)</tem:SessionId>" +
            "<!--Optional:-->" +
            "<tem:DeviceId>5B47E42C-16BE-4479-92B5-2C31633AD9D4</tem:DeviceId>" +  // \(UserDefaults.standard.string(forKey: "DevideId")!)
            "<!--Optional:-->" + 
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Order_SaveV2>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Order_SaveV2"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if error != nil{
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
