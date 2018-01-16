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
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var bienSoLabel: UILabel!
    @IBOutlet weak var tuyenDuongLabel: UILabel!
    @IBOutlet weak var taixephuxeLabel: UILabel!
    @IBOutlet weak var schemaWebView: UIWebView!
    @IBOutlet weak var topbar: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
        ref = Database.database().reference(withPath: "m-taixe")
        getXMLMapView()
        getStatusBookedByTrip()
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
        default:
            break
        }
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
        self.bienSoLabel.text = LicensePlate
        self.tuyenDuongLabel.text = DepartName + " -> " + ArrivalName
        self.taixephuxeLabel.text = "Tài xế: " + DriverName + " -  Phụ xe: " + EmployeeName
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
                self.saveSeatsToFireBase()
                self.schemaWebView.stringByEvaluatingJavaScript(from: "clearAllTicket()")
                for seat in self.seats {
                    self.arrChooseSeatId.append(String(seat.SeatID))
                    
                    if seat.Status == 32 {
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seat.SeatID)', true)")
                    }
                    
                    if seat.Status == 11 {
                        if self.seatsID.contains(String(seat.SeatID)) {
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "myChoose('\(seat.SeatID)', true)")
                        } else {
                            self.schemaWebView.stringByEvaluatingJavaScript(from: "chooseSeat('\(seat.SeatID)', true)")
                        }
                    }
                    
                    if seat.Status == 12 {
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seat.SeatID)', true)")
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "m-taixe" {
            if let seatId = request.url?.query {
                if arrChooseSeatId.contains(seatId) {
                    let dataString = SchemaApi.Ticket_CheckExistsV2(TripId: tripId, SeatId: seatId, DepartGuid: self.DepartGuid, ArrivalGuid: self.ArrivalGuid)
                } else {
                    if arrMyChooseSeatId.contains(seatId) {
                        arrMyChooseSeatId = arrMyChooseSeatId.filter{ $0 != seatId }
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "unchoose('\(seatId)')")
//                        self.schemaWebView.stringByEvaluatingJavaScript(from: "resetSeat('\(seatId)')")
                        
                    } else {
                        arrMyChooseSeatId.append(seatId)
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "chooseSeat('\(seatId)')")
                        self.schemaWebView.stringByEvaluatingJavaScript(from: "setSeat('\(seatId)', true)")
                    }
                }
            }
        }
        return true
    }
    
    // MARK: - Firebases
    
    func saveSeatsToFireBase() {
        let itemsRef = ref.child("seat-items")
        for seat in seats {
//            let item = Seat(SeatID: seat.SeatID, seatName: seat.seatName, Status: seat.Status)
//            itemsRef.setValue(item)
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
    }
    
}
