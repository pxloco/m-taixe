//
//  EditRouteViewController.swift
//  M-Taixe
//
//  Created by M on 12/16/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit
import DropDown
import HPUIViewExtensions
import UICheckbox_Swift

class EditRouteViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var txtPhuongTien: UITextField!
    @IBOutlet weak var txtTuyen: UITextField!
    @IBOutlet weak var txtGiaVe: UITextField!
    @IBOutlet weak var txtTaiXe: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtDtChuyen: UITextField!
    @IBOutlet weak var txtBienSo: UITextField!
    @IBOutlet weak var checkboxBanOnline: UICheckbox!
    @IBOutlet weak var checkboxCoGhe: UICheckbox!
    @IBOutlet weak var checkboxChoDaiLyBan: UICheckbox!
    @IBOutlet weak var checkboxChoDatCoc: UICheckbox!
    @IBOutlet weak var checkboxGGioiHanNguoiBan: UICheckbox!
    @IBOutlet weak var checkboxLuuGiu: UICheckbox!
    @IBOutlet weak var shadowntopbar: UIView!
    @IBOutlet weak var labelTimeStart: UILabel!
    @IBOutlet weak var btnHuyChuyen: HPButton!
    
    var arrPhuongTien = [Bus]()
    var arrTuyen = [Route]()
    var arrGiaVe = [TicketByBus]()
    var currentPhuongTien = Bus()
    var currentTuyen = Route()
    var currentGiaVe = TicketByBus()
    var jsonHelper = JsonHelper()
    var currentUser = User()
    var alert = SCLAlertView()
    var timeStart = ""
    var formatter = DateFormatter()
    var tripId = String()
    var IsLockedAgent = Bool()
    var IsFixed = Bool()
    var AllowTrustDebit = Bool()
    var UseFloorSeat = Bool()
    var currentTrip = Trip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDefaultParam()
        setUpUI()
        setUpView()
        loadPhuongTien()
        loadRoute()
    }
    
    func setUpView() {
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 1000)
    }
    
    func setUpUI() {
        if self.currentTrip.TripId == "00000000-0000-0000-0000-000000000000" {
            titleLabel.text = "Thêm chuyến"
            btnHuyChuyen.isHidden = true
            //lấy ngày hiện tại
            formatter.dateFormat = "HHmm"
            let d = Date()
            timeStart = currentTrip.StartDate + formatter.string(from: d)
            formatter.dateFormat = "HH:mm"
            labelTimeStart.text = formatter.string(from: d)
        } else {
            titleLabel.text = "Sửa thông tin chuyến"
            btnHuyChuyen.isHidden = false
            
            txtBienSo.text = currentTrip.LicensePlate
            txtTaiXe.text = currentTrip.DriversName
            txtTaiXe.text = currentTrip.Title
            
            if currentTrip.AllowTrustDebit {
                checkboxChoDatCoc.isSelected = true
            } else {
                checkboxChoDatCoc.isSelected = false
            }
            
            if currentTrip.IsFixed {
                checkboxBanOnline.isSelected = true
            } else {
                checkboxBanOnline.isSelected = false
            }
            
            if currentTrip.IsLockedAgent {
                checkboxChoDaiLyBan.isSelected = true
            } else {
                checkboxChoDaiLyBan.isSelected = false
            }
            
            currentGiaVe.MapTicketPriceID = currentTrip.BusPriceID
            currentTuyen.RouteId = currentTrip.RouteId
            currentPhuongTien.BusId = currentTrip.BusPriceID
            
            let arrdate = currentTrip.StartDate.components(separatedBy: ":")
            let currentDate = arrdate[2] + arrdate[1] + arrdate[0]
            //lấy ngày hiện tại
            formatter.dateFormat = "HHmm"
            let d = Date()
            timeStart = currentDate + formatter.string(from: d)
            formatter.dateFormat = "HH:mm"
            labelTimeStart.text = formatter.string(from: d)
        }
        
        AppUtils.addShadowToView(view: shadowntopbar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
        
    }
    
    func setUpUserDefaultParam() {
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
    
    func setUpDataFromCategory(tripId: String, dateFromCategory: String) {
        self.currentTrip.TripId = tripId
        self.currentTrip.StartDate = dateFromCategory
    }
    
    func setUpDataFromSchema(trip: Trip) {
        currentTrip = trip
        tripId = trip.TripId
    }
    
    // MARK: - User Action
    
    @IBAction func phuongTienDropdown(_ sender: Any) {
        let dropDown = DropDown()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        dropDown.anchorView = self.txtPhuongTien
        
        var arrDropDown = [String]()
        for busName in self.arrPhuongTien {
            arrDropDown.append(busName.LicensePlate)
        }
        
        dropDown.dataSource = arrDropDown
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtPhuongTien.text = item
            self.currentPhuongTien = self.arrPhuongTien[index]
        }
        
        dropDown.show()
    }
    
    @IBAction func tuyenDropdown(_ sender: Any) {
        let dropDown = DropDown()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        dropDown.anchorView = self.txtTuyen
        
        var arrDropDown = [String]()
        for route in self.arrTuyen {
            arrDropDown.append(route.Name)
        }
        
        dropDown.dataSource = arrDropDown
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtTuyen.text = item
            self.currentTuyen = self.arrTuyen[index]
        }
        
        dropDown.show()
    }
    
    @IBAction func giaVeDropdown(_ sender: Any) {
        let dropDown = DropDown()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        dropDown.anchorView = self.txtGiaVe
        
        var arrDropDown = [String]()
        for ve in self.arrGiaVe {
            arrDropDown.append(ve.Title)
        }
        
        dropDown.dataSource = arrDropDown
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtGiaVe.text = item
            self.currentGiaVe = self.arrGiaVe[index]
        }
        
        dropDown.show()
    }
    
    @IBAction func btnGioXuatPhat(_ sender: Any) {
        let datePicker = DatePickerDialog()
        formatter.dateFormat = "yyyyMMddHHmm"
        datePicker.defaultDate = formatter.date(from: timeStart)
        datePicker.show("Chọn giờ xuất phát", doneButtonTitle: "Chọn", cancelButtonTitle: "Huỷ", datePickerMode: .time) {
            (date) -> Void in
            self.formatter.dateFormat = "HH:mm"
            self.labelTimeStart.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "HHmm"
            self.timeStart = self.currentTrip.StartDate + self.formatter.string(from: date)
        }
    }
    
    @IBAction func btnHuyChuyen(_ sender: Any) {
        self.deleteTrip()
    }
    
    @IBAction func btnLuu(_ sender: Any) {
        IsLockedAgent = checkboxChoDaiLyBan.isSelected
        IsFixed = checkboxBanOnline.isSelected
        AllowTrustDebit = checkboxBanOnline.isSelected
        UseFloorSeat = checkboxCoGhe.isSelected
        
        saveTrip(BusId: currentPhuongTien.BusId, Title: txtTaiXe.text ?? "", StartTime: timeStart, TimeOnRoad: "-1", BusPriceID: currentGiaVe.MapTicketPriceID, RouteId: currentTuyen.RouteId, Status: "1", IsLockedAgent: IsLockedAgent, IsFixed: IsFixed, AllowTrustDebit: AllowTrustDebit, UseFloorSeat: UseFloorSeat, Mobile: txtDtChuyen.text ?? "", LicensePlate: txtBienSo.text ?? "")
    }
    
    @IBAction func btnHuy(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: Helper
    
    // MARK: GET data from API
    
    func loadPhuongTien() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetBusList>" +
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
            "</tem:Trip_GetBusList>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetBusList"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                self.arrPhuongTien = self.jsonHelper.parseBus(data!)
                if self.arrPhuongTien.count > 0 {
                    for phuongtien in self.arrPhuongTien {
                        if phuongtien.BusId == self.currentPhuongTien.BusId {
                            self.txtPhuongTien.text = phuongtien.LicensePlate
                            self.currentPhuongTien = phuongtien
                            break
                        } else {
                            self.txtPhuongTien.text = self.arrPhuongTien[0].LicensePlate
                            self.currentPhuongTien = self.arrPhuongTien[0]
                            self.loadGiaVe(busId: self.currentPhuongTien.BusId)
                        }
                    }
                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadRoute() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Route_GetForBooking>" +
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
            "</tem:Route_GetForBooking>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Route_GetForBooking"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                self.arrTuyen = self.jsonHelper.parseRoutes(data!)
                
                if self.arrTuyen.count > 0 {
                    for route in self.arrTuyen {
                        if route.RouteId == self.currentTuyen.RouteId {
                            self.txtTuyen.text = route.Name
                            self.currentTuyen = route
                            break
                        } else {
                            self.txtTuyen.text = self.arrTuyen[0].Name
                            self.currentTuyen = self.arrTuyen[0]
                        }
                    }
                }
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadGiaVe(busId: Int) {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetTicketPriceByBus>" +
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
            "<tem:BusId>\(busId)</tem:BusId>" +
            "</tem:Trip_GetTicketPriceByBus>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetTicketPriceByBus"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                self.arrGiaVe = self.jsonHelper.parseTicketPriceByBus(data!)
                
                if self.arrGiaVe.count > 0 {
                    for giave in self.arrGiaVe {
                        if giave.MapTicketPriceID == self.currentTrip.BusPriceID {
                            self.txtGiaVe.text = giave.Title
                            self.currentGiaVe = giave
                            break
                        } else {
                            self.txtGiaVe.text = self.arrGiaVe[0].Title
                            self.currentGiaVe = self.arrGiaVe[0]
                        }
                    }
                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func deleteTrip() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_Delete>" +
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
            "<tem:TripId>\(currentTrip.TripId)</tem:TripId>" +
            "</tem:Trip_Delete>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_Delete"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                if String(data: data!, encoding: String.Encoding.utf8) as String! == "true" {
                    let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]
                    self.navigationController?.popToViewController(controller!, animated: true)
                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func saveTrip(BusId: Int, Title: String, StartTime: String, TimeOnRoad: String, BusPriceID: Int, RouteId: Int, Status: String, IsLockedAgent: Bool, IsFixed: Bool, AllowTrustDebit: Bool, UseFloorSeat: Bool, Mobile: String, LicensePlate: String) {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_Save>" +
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
            "<tem:TripId>\(currentTrip.TripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:BusId>\(BusId)</tem:BusId>" +
            "<!--Optional:-->" +
            "<tem:Title>\(Title)</tem:Title>" +
            "<!--Optional:-->" +
            "<tem:StartTime>\(StartTime)</tem:StartTime>" +
            "<!--Optional:-->" +
            "<tem:TimeOnRoad>\(TimeOnRoad)</tem:TimeOnRoad>" +
            "<!--Optional:-->" +
            "<tem:BusPriceID>\(BusPriceID)</tem:BusPriceID>" +
            "<!--Optional:-->" +
            "<tem:RouteId>\(RouteId)</tem:RouteId>" +
            "<!--Optional:-->" +
            "<tem:Status>\(Status)</tem:Status>" +
            "<!--Optional:-->" +
            "<tem:IsLockedAgent>\(IsLockedAgent)</tem:IsLockedAgent>" +
            "<!--Optional:-->" +
            "<tem:IsFixed>\(IsFixed)</tem:IsFixed>" +
            "<!--Optional:-->" +
            "<tem:AllowTrustDebit>\(AllowTrustDebit)</tem:AllowTrustDebit>" +
            "<!--Optional:-->" +
            "<tem:UseFloorSeat>\(UseFloorSeat)</tem:UseFloorSeat>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(Mobile)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:LicensePlate>\(LicensePlate)</tem:LicensePlate>" +
            "</tem:Trip_Save>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_Save"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                if self.currentTrip.TripId == "00000000-0000-0000-0000-000000000000" {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    //let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]
                    
                    let storyboard = UIStoryboard.init(name: "Schema", bundle: Bundle.main)
                    let schemaController = storyboard.instantiateViewController(withIdentifier: "Schema") as! SchemaViewController
                    schemaController.initDataFromUpdateRoute(bienso: LicensePlate)
                    //schemaController.bienSoLabel.text =
                    
                    self.navigationController?.popViewController(animated: true)
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
