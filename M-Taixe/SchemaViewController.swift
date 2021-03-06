//
//  SchemaViewController.swift
//  M-Taixe
//
//  Created by M on 12/11/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase
import HPUIViewExtensions
import HPXibDesignable

class SchemaViewController: UIViewController, UIWebViewDelegate {

    var currentUser = User()
    var tripId = String()
    var gioXuatBen = ""
    var mapXML = String()
    var alert = SCLAlertView()
    var seats = [Seat]()
    var jsonHelper = JsonHelper()
    var seatsID = [String]()
    var arrMyChooseSeatId = [String]()
    var arrChooseSeatId = [String]()
    var DepartGuid = String()
    var ArrivalGuid = String()
    var DepartName = String()
    var ArrivalName = String()
    var LicensePlate = String()
    var DriverName = String()
    var EmployeeName = String()
    var currentTrip = Trip()
    var ticket = Ticket()
    var reportInTrips = [ReportInTrip]()
    var seatNames = [String]()
    var customers = [Customer]()
    var currentCustomers = Customer()
    
    let ref = Database.database().reference(withPath: "tickets")
    
    @IBOutlet weak var bienSoLabel: UILabel!
    @IBOutlet weak var tuyenDuongLabel: UILabel!
    @IBOutlet weak var taixephuxeLabel: UILabel!
    @IBOutlet weak var schemaWebView: UIWebView!
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var analysLabel: UILabel!
    @IBOutlet weak var btnAddSeat: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemTripIdRef = self.ref.child("\(tripId)")
        itemTripIdRef.observe(.value, with: { snapshot in
            var newItems: [Seat] = []
            
            for item in snapshot.children {
                // 4
                let seatItem = Seat(snapshot: item as! DataSnapshot)
                newItems.append(seatItem)
            }
            
            // 5
            self.seats = newItems
            self.getXMLMapView()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setUpData()
            self.setUpUI()
            self.getXMLMapView()
            self.getStatusBookedByTrip()
            self.getReportByTrip()
            self.btnAddSeat.isHidden = true
            self.seatNames.removeAll()
            self.schemaWebView.stringByEvaluatingJavaScript(from: "clearAllTicket()")
            self.loadAllCustomer()
        }
    }
    
    // MARK: - Init

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case SegueFactory.fromSchemaToEditRoute.rawValue:
            (segue.destination as! EditRouteViewController).setUpDataFromSchema(trip: currentTrip)
        case SegueFactory.fromSchemaToEditDriver.rawValue:
            (segue.destination as! EditDriverViewController).initData(trip: currentTrip)
        case SegueFactory.fromSchemaToChangeCar.rawValue:
            (segue.destination as! ChangeCarViewController).initData(tripId: currentTrip.TripId)
        case SegueFactory.fromSchemaToAddSeat.rawValue:
            
            let ticket = sender as! Ticket
            (segue.destination as! AddSeatViewController).initDataFromShema(tripId: currentTrip.TripId, currentUser: currentUser, currentTrip: currentTrip, ticket: ticket, seatInOrder: currentCustomers.SeatInOrder)
        default:
            break
        }
    }
    
    func initDataFromUpdateDriver(DriverName: String, EmployeeName: String) {
        self.DriverName = DriverName
        self.EmployeeName = EmployeeName
    }
    
    func initDataFromCategory(DepartGuid: String, DepartName: String, ArrivalGuid: String, ArrivalName: String, DriverName: String, EmployeeName: String, trip: Trip) {
        self.tripId = trip.TripId
        self.LicensePlate = trip.LicensePlate
        self.gioXuatBen = trip.StartTime
        self.DepartGuid = DepartGuid
        self.ArrivalGuid = ArrivalGuid
        self.DepartName = DepartName
        self.ArrivalName = ArrivalName
        self.currentTrip = trip
        self.DriverName = trip.DriversName
        self.EmployeeName = trip.EmployeesName
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
    }
    
    func setUpUI() {
        self.bienSoLabel.text = self.LicensePlate
        self.tuyenDuongLabel.text = DepartName + " -> " + ArrivalName
        self.taixephuxeLabel.text = "Tài xế: " + self.DriverName + " -  Phụ xe: " + self.EmployeeName
        AppUtils.addShadowToView(view: topbar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    func btnListCustomerClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnMapClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Get data
    
    func getXMLMapView () {
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
                "<tem:TripId>\(self.tripId)</tem:TripId>" +
                "</tem:Map_GetMapXML>" +
                "</soapenv:Body>" +
            "</soapenv:Envelope>"
            
            sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
                    if error == nil {
                        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                        
                        dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                        dataString = AppUtils.HTMLEntityDecode(htmlEncodedString: dataString)
                        self.loadMapWithScrip(htmlDecoded: dataString)
                    }
                    else {
                        alert.hideView()
                        alert = SCLAlertView()
                        alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
                    }
            }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        getStatusBookedByTrip()
    }
    
    func checkVisibleAddSeat() {
        if seatNames.isEmpty {
            btnAddSeat.isHidden = true
        } else {
            btnAddSeat.isHidden = false
        }
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        DispatchQueue.main.async {
            if request.url?.scheme == "m-taixe" {
                if let seatData = request.url?.query {
                    let searArr = seatData.components(separatedBy: "?")
                    let seatId    = searArr[0]
                    let seatName  = searArr[1]
                    self.Ticket_CheckExistsV2(TripId: self.tripId, SeatId: seatId, DepartGuid: self.DepartGuid, ArrivalGuid: self.ArrivalGuid)
                    var statusSeatChoose: Int = 0
                    var bookingClerkId = String()
                    var sessionId = String()
                    if self.arrChooseSeatId.contains(seatId) {
                        //                    for seat in seats {
                        //                        if seat.SeatID == Int(seatId) {
                        //                            statusSeatChoose = seat.Status
                        //                        }
                        //                    }
                        
                        
                        
                        if self.ticket.Status == 11 && self.ticket.SessionId == UserDefaults.standard.string(forKey: "SessionId"){
                            for customer in self.customers {
                                if customer.SeatInOrder.contains(seatName) {
                                    self.currentCustomers = customer
                                    self.performSegue(withIdentifier: SegueFactory.fromSchemaToAddSeat.rawValue, sender: (ticket: self.ticket))
                                }
                            }
                        } else {
                            self.alert.showInfo("Thông tin!", subTitle: "Ghế đã được chọn bởi \(self.ticket.BookingClerkName).")
                        }
                    } else {
                        if self.arrMyChooseSeatId.contains(seatId) {
                            self.arrMyChooseSeatId = self.arrMyChooseSeatId.filter{ $0 != seatId }
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "unchoose('\(seatId)')")
                            //                        self.schemaWebView.stringByEvaluatingJavaScript(from: "resetSeat('\(seatId)')")
                            self.seatNames = self.seatNames.filter { $0 != seatName }
                            self.checkVisibleAddSeat()
                        } else {
                            self.arrMyChooseSeatId.append(seatId)
                            self.seatNames.append(seatName)
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "myChoose('\(seatId)', true)")
                            self.checkVisibleAddSeat()
                            //                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seatId)', true)")
                        }
                    }
                }
            }
        }

        return true
    }
    
    // MARK: - Firebases
    
    func saveSeatsToFireBase(seats: [Seat]) {
        for seat in seats {
            let itemTripIdRef = self.ref.child("\(tripId)")
            let itemRef = itemTripIdRef.child("\(seat.OrderGuid)")
            itemRef.setValue(seat.toAnyObject())
        }
    }
    
    
//    if (seatStatus.getTicket().Status == 11 && seatStatus.getTicket().BookingClerkId == CurrentUser.getUserId()&& seatStatus.getTicket().SessionId.equals(CurrentSession.getSessionId()))
    
    func loadMapWithScrip(htmlDecoded: String) {
        let map = SchemaApi.replaceHtmlWithJavascrip(htmlDecoded: htmlDecoded)
        self.schemaWebView.loadHTMLString(map, baseURL: nil)
    }
    
    @IBAction func homeClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editRouteAction(_ sender: Any) {
        performSegue(withIdentifier: SegueFactory.fromSchemaToEditRoute.rawValue, sender: nil)
    }
    
    @IBAction func editDriverAction(_ sender: Any) {
        performSegue(withIdentifier: SegueFactory.fromSchemaToEditDriver.rawValue, sender: nil)
    }
    
    @IBAction func changeCarAction(_ sender: Any) {
        performSegue(withIdentifier: SegueFactory.fromSchemaToChangeCar.rawValue, sender: nil)
    }
    
    @IBAction func listGoodsAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
        let customerController =  tabBarController?.viewControllers![1] as! CustomersController
        customerController.segmentControl.selectedSegmentIndex = 2
        customerController.addGoodsButton.isHidden = false
    }
    
    @IBAction func analysByTrip(_ sender: Any) {
    }
    
    @IBAction func addSeatAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard.init(name: "Schema", bundle: Bundle.main)
        let addController = storyboard.instantiateViewController(withIdentifier: "AddSeat") as! AddSeatViewController
        addController.tripId = tripId
        addController.currentUser = currentUser
        addController.arrSeat = seatNames
        self.navigationController?.pushViewController(addController, animated: false)
    }
    
    
    func getStatusBookedByTrip() {
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
                
                self.seats = self.jsonHelper.parseSeats(dataString)
                self.saveSeatsToFireBase(seats: self.seats)
                self.schemaWebView.stringByEvaluatingJavaScript(from: "clearAllTicket()")
                for seat in self.seats {
                    self.arrChooseSeatId.append(String(seat.SeatID))
                    
                    //
                    if seat.Status == 32 {
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seat.SeatID)', true)")
                    }
                    
                    // Seat đã chọn
                    if seat.Status == 11 {
                        // mình chọn
                        if self.seatsID.contains(String(seat.SeatID)) {
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "myChoose('\(seat.SeatID)', true)")
                        } else { // Đã chọn rồi
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "chooseSeat('\(seat.SeatID)', true)")
                        }
                    }
                    
                    //
                    if seat.Status == 12 {
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seat.SeatID)', false)")
                    }
                }
            }
            else {
                alert.hideView()
                alert = SCLAlertView()
                alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func Ticket_CheckExistsV2(TripId: String, SeatId: String, DepartGuid: String, ArrivalGuid: String) {
        let sendPostRequest = SendPostRequest()
        var dataString = Data()
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
                dataString = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                self.ticket = self.jsonHelper.parseTicket(dataString)
                
//                self.performSegue(withIdentifier: SegueFactory.fromSchemaToAddSeat.rawValue, sender: self.ticket)
                
            }
            else {
                alert.hideView()
                alert = SCLAlertView()
                alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func getReportByTrip() {
        let sendPostRequest = SendPostRequest()
        var dataString = Data()
        var alert = SCLAlertView()
        let soapAction = "http://tempuri.org/IMobihomeWcf/Order_ReportInTrip"
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Order_ReportInTrip>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(UserDefaults.standard.value(forKey: "UserName")!)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(UserDefaults.standard.value(forKey: "Password")!)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "</tem:Order_ReportInTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                dataString = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                self.reportInTrips = self.jsonHelper.parseReportInTrip(dataString)
                
                var totalTicket = Int()
                var totalAmount = Int()
                var totalAmoutPaid = Int()
                var totalTicketPaid = Int()
                
//                var SellerName = String()
//                var TotalAmount = Int()
//                var TotalAmountPaid = Int()
//                var CountOrder = Int()
//                var CountTicket = Int()
//                var CountTicketPaid = Int()
//                var CountBill = Int()
//                var BillAmount = Int()
//                var CountBillPaid = Int()
//                var BillPaidAmount = Int()
                
                for report in self.reportInTrips {
                    totalTicket += report.CountTicket
                    totalTicketPaid += report.CountTicketPaid
                    totalAmount += report.TotalAmount
                    totalAmoutPaid += report.TotalAmountPaid
                }
                
                self.analysLabel.text = "Vé (\(totalTicket)): \(totalAmount), Thanh toán ((\(totalAmount)): \(totalAmoutPaid) VNĐ"
                
            }
            else {
                alert.hideView()
                alert = SCLAlertView()
                alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadAllCustomer() {
        let soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:Order_GetByTrip><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:TripId>\(tripId)</tem:TripId><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:Order_GetByTrip></soapenv:Body></soapenv:Envelope>")
        let soapAction = "http://tempuri.org/IMobihomeWcf/Order_GetByTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            self.alert.hideView()
            if error == nil{
                if string != "" {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.customers = self.jsonHelper.parseCustomers(data!)
                }
                else{
                    //Thông báo lỗi server
                    
                }
            }
            else{
                
            }
        }
    }
}
