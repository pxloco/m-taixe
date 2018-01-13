//
//  CategoryController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import HPUIViewExtensions
import DropDown
import SwiftyAttributes

class CategoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var btnChooseRoute: HPButton!
    @IBOutlet weak var collectionViewCatagory: UICollectionView!
    @IBOutlet weak var labelDiemDi: UILabel!
    @IBOutlet weak var labelDiemDen: UILabel!
    @IBOutlet weak var btnDiemDi: UIButton!
    @IBOutlet weak var btnDiemDen: UIButton!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var thongKeVeLabel: UILabel!
    @IBOutlet weak var thongKeHangLabel: UILabel!
    
    var tripJson = Data()
    var currentUser = User()
    var arrTrip = [Trip]()
    var jsonHelper = JsonHelper()
    var alert = SCLAlertView()
    var date = "20160714"
    var userDefaults = UserDefaults.standard
    var formatter = DateFormatter()
    var timer = Timer()
    var currentRoute = Route()
    var routes = [Route]()
    var isChooseRoute = false
    var overTop = false
    var sendPostRequest = SendPostRequest()
    var locationStartPoint = [Location]()
    var locationEndPoint = [Location]()
    var currentlocationStartPoint = Location()
    var currentlocationEndPoint = Location()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        //Load dữ liệu ngày hôm qua lưu xuống local
//        var currentDate = Date()
//        currentDate = currentDate.addingTimeInterval(TimeInterval(-1*60*60*24))
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "yyyyMMdd"
//        backgroundThread(0.0, background: {
//            self.loadData(dateFormat.string(from: currentDate), choose: false)
//        })
        
//        //Load dữ liệu ngày mai lưu xuống local
//        currentDate = currentDate.addingTimeInterval(TimeInterval(1*60*60*24))
//        backgroundThread(0.0, background: {
//            self.loadData(dateFormat.string(from: currentDate), choose: false)
//        })
//        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(CategoryController.timerTask), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.setUpData()
            self.loadDiaDiemDi()
            self.loadRoute()
            self.overTop = false
            self.collectionViewCatagory.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionViewCatagory.contentOffset.y < -30{
            overTop = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case SegueFactory.fromCategoryToSchema.rawValue:
            let indexPath = sender as! IndexPath
            let schemaTabBarViewController = segue.destination as! SchemaTabBarViewController
            for viewController in schemaTabBarViewController.viewControllers! {
                if viewController is SchemaViewController {
                    (viewController as! SchemaViewController).initDataFromCategory(
                        DepartGuid: currentlocationStartPoint.LocationID,
                        DepartName: currentlocationStartPoint.Name,
                        ArrivalGuid: currentlocationEndPoint.LocationID,
                        ArrivalName: currentlocationEndPoint.Name,
                        DriverName: arrTrip[(indexPath as NSIndexPath).row].DriversName,
                        EmployeeName: arrTrip[(indexPath as NSIndexPath).row].EmployeesName,
                        trip: arrTrip[indexPath.row])
                }
            }
        case SegueFactory.fromCategoryToEditCategory.rawValue:
            (segue.destination as! EditRouteViewController).setUpDataFromCategory(tripId: "00000000-0000-0000-0000-000000000000", dateFromCategory: self.date)
        case SegueFactory.fromCategoryToGoods.rawValue:
            (segue.destination as! ListGoodsViewController).initData(trips: arrTrip, currentDate: self.date)
        default:
            break
        }
    }
    
    // - MARK: Init
    
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
        //lấy ngày hiện tại
        formatter.dateFormat = "yyyyMMdd"
        let d = Date()
        date = formatter.string(from: d)
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: d)
        
        AppUtils.addShadowToView(view: topBar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    // - MARK: Connect SOAP
    
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
                self.routes = self.jsonHelper.parseRoutes(data!)
                if self.routes.count > 0 {
                    self.currentRoute = self.routes[0]
                    self.btnChooseRoute.setTitle(self.currentRoute.Name, for: UIControlState.normal)
                }
                else {
                    self.currentRoute = Route()
                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadRouteDenDropDown() {
        let dropDown = DropDown()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        dropDown.anchorView = self.btnChooseRoute
        
        var arrDropDown = [String]()
        for route in self.routes {
            arrDropDown.append(route.Name)
        }
        
        dropDown.dataSource = arrDropDown
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelDiemDi.text = item
            self.currentRoute = self.routes[index]
        }
    
        dropDown.show()
    }
    
    func loadDiaDiemDi() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:Place_SearchAllDepart><!--Optional:--><tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId><!--Optional:--><tem:AgentId>\(currentUser.AgentId)</tem:AgentId><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode><!--Optional:--><tem:SearchText></tem:SearchText></tem:Place_SearchAllDepart></soapenv:Body></soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchAllDepart"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.locationStartPoint = self.jsonHelper.parseRouteLocation(data!)
                    self.labelDiemDi.text = self.locationStartPoint[0].Name
                    self.currentlocationStartPoint = self.locationStartPoint[0]
                    self.loadDiaDiemDen()
                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadDiaDiemDiLenDropDown() {
        if self.locationStartPoint.count > 0 {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.black
            DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
            DropDown.appearance().cellHeight = 60
            
            // The view to which the drop down will appear on
            dropDown.anchorView = self.labelDiemDi // UIView or UIBarButtonItem
            
            var arrDropDown = [String]()
            for location in self.locationStartPoint {
                arrDropDown.append(location.Name)
            }
            
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = arrDropDown
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.labelDiemDi.text = item
                self.currentlocationStartPoint = self.locationStartPoint[index]
                self.loadDanhSachXe(self.date, choose: true)
            }
            
            // Will set a custom width instead of the anchor view width
            dropDown.show()
        }
        else {
            self.currentlocationStartPoint = Location()
        }
    }
    
    func loadDiaDiemDen() {
        if currentlocationStartPoint.LocationID == "" {
            return
        }
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
        "<soapenv:Header/>" +
        "<soapenv:Body>" +
        "<tem:Place_SearchAllArrival>" +
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
        "<tem:DepartPlaceId>\(currentlocationStartPoint.LocationID)</tem:DepartPlaceId>" +
        "<!--Optional:-->" +
        "<tem:SearchText></tem:SearchText>" +
        "</tem:Place_SearchAllArrival>" +
        "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchAllArrival"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.locationEndPoint = self.jsonHelper.parseRouteLocation(data!)
                    self.labelDiemDen.text = self.locationEndPoint[0].Name
                    self.currentlocationEndPoint = self.locationEndPoint[0]
                    self.loadDanhSachXe(self.date, choose: true)
                }
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadDiaDiemDenLenDropDown() {
        if self.locationEndPoint.count > 0 {
            let dropDown = DropDown()
            DropDown.appearance().textColor = UIColor.black
            DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
            DropDown.appearance().cellHeight = 60
            
            // The view to which the drop down will appear on
            dropDown.anchorView = self.labelDiemDi // UIView or UIBarButtonItem
            
            var arrDropDown = [String]()
            for location in self.locationEndPoint {
                arrDropDown.append(location.Name)
            }
            
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = arrDropDown
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.labelDiemDen.text = item
                self.currentlocationEndPoint = self.locationEndPoint[index]
                self.loadDanhSachXe(self.date, choose: true)
            }
            
            // Will set a custom width instead of the anchor view width
            dropDown.show()
        }
        else {
            self.currentlocationEndPoint = Location()
        }
    }
    
    func loadDanhSachXe(_ byDate: String, choose: Bool) {
        if self.currentlocationStartPoint.LocationID == "" && self.currentlocationEndPoint.LocationID == "" {
            return
        }
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
        "<soapenv:Header/>" +
        "<soapenv:Body>" +
        "<tem:Trip_FilterForBooking>" +
        "<!--Optional:-->" +
        "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
        "<!--Optional:-->" +
        "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
        "<!--Optional:-->" +
        "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
        "<!--Optional:-->" +
        "<tem:Password>\(currentUser.Password)</tem:Password>" +
        "<!--Optional:-->" +
        "<tem:TripDate>\(byDate)</tem:TripDate>" +
        "<!--Optional:-->" +
        "<tem:DepartGuid>\(currentlocationStartPoint.LocationID)</tem:DepartGuid>" +
        "<!--Optional:-->" +
        "<tem:ArrivalGuid>\(currentlocationEndPoint.LocationID)</tem:ArrivalGuid>" +
        "<!--Optional:-->" +
        "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
        "</tem:Trip_FilterForBooking>" +
        "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_FilterForBooking"
        let sendPostRequest = SendPostRequest()
        //Gửi yêu cầu lấy danh sách chuyến trong ngày "bydate"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            if error == nil {
                
                //Parse dữ liệu trả về sang NSData
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                var trips = [Trip]()
                
                //Chuyển sang danh sách chuyến
                trips = self.jsonHelper.parseTrips(data!)
                
                //Nếu có dữ liẹu trả về từ server thì lưu xuống bộ nhớ local
                if string != "" {
                    self.userDefaults.setValue(data, forKey: byDate)
                    self.userDefaults.synchronize()
                }
                
                //Nếu là load ngày dc chọn
                if self.date == byDate {
                    self.arrTrip = [Trip]()
                    self.alert.hideView()
                    
                    //Nếu ko nhận dc dữ liệu từ server (server lỗi)
                    if string == ""{
                        if choose{
                            self.alert = SCLAlertView()
                            self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
                        }
                        //Lấy danh sách chuyến từ local
                        let jsonTrips = self.userDefaults.value(forKey: self.date) as? NSData
                        if jsonTrips != nil{
                            self.arrTrip = self.jsonHelper.parseTrips(jsonTrips! as Data)
                        }
                        self.collectionViewCatagory.reloadData()
                    }
                    else{
                        
                        //Load dữ liệu của server trả về
                        self.arrTrip = trips
                        var tongSoTienVeBanDuoc: Int = 0
                        var tongSoTienVeChuaThanhToan: Int = 0
                        var tongSoVeBanDuoc: Int = 0
                        var tongSoVeChuaThanhToan: Int = 0
                        var tongSoHangChuaTien: Int = 0
                        var tongSoTienHangChuaTien: Int = 0
                        
                        for trip in self.arrTrip {
                            tongSoTienVeBanDuoc += trip.TicketAmount
                            tongSoTienVeChuaThanhToan += trip.TicketAmount - trip.TicketPaidAmount
                            tongSoVeBanDuoc += trip.CountBooked
                            tongSoVeChuaThanhToan += trip.CountBooked - trip.CountPaid
                            tongSoHangChuaTien += trip.BillFreightCount - trip.BillFreightPaidCount
                            tongSoTienHangChuaTien += trip.BillFreightAmount - trip.BillFreightPaidAmount
                        }
                        
                        let tongSoTienVeBanDuocAttr = "\(tongSoTienVeBanDuoc)".withAttributes([.textColor(.red)])
                        let tongSoTienVeChuaThanhToanAttr = "\(tongSoTienVeChuaThanhToan)".withAttributes([.textColor(.red)])
                        let tongSoVeBanDuocAttr = "\(tongSoVeBanDuoc)".withAttributes([.textColor(.black)])
                        let tongSoVeChuaThanhToanAttr = "\(tongSoVeChuaThanhToan)".withAttributes([.textColor(.black)])
                        let tongSoTienHangAttr = "\(tongSoTienHangChuaTien)".withAttribute(.textColor(.red))
                        let tongSoHangAttr = "\(tongSoHangChuaTien)".withAttribute(.textColor(.black))
                    
                        let sove = "Số vé: ".withAttributes([.textColor(.black)])
                        let mongoac = " ( ".withAttributes([.textColor(.black)])
                        let dongngoac = " )".withAttributes([.textColor(.black)])
                        let gach = " - ".withAttributes([.textColor(.black)])
                        let chuathanhtoan = " chưa thanh toán".withAttributes([.textColor(.black)])
                        let hang = "Hàng: ".withAttribute(.textColor(.black))
                        
                        self.thongKeVeLabel.attributedText = sove + tongSoVeBanDuocAttr + gach + tongSoTienVeBanDuocAttr + mongoac + tongSoVeChuaThanhToanAttr + gach + tongSoTienVeChuaThanhToanAttr + chuathanhtoan + dongngoac
                        self.thongKeHangLabel.attributedText = hang + tongSoHangAttr + mongoac + tongSoTienHangAttr + dongngoac
                        
                        self.collectionViewCatagory.reloadData()
                    }
                }
                
                //Chạy ngầm tính năng lưu dữ liệu xuống local
                self.backgroundThread(0.0, background: {
                    
                    //Lưu danh sách khách hàng của từng chuyến
                    for i in 0 ..< trips.count {
                        let trip = trips[i]
                        self.insertCustomer(trip.TripId, atDate: byDate)
                    }
                    
                    //Xoá dữ liệu cách đây 30ngày
                    var currentDate = NSDate()
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyyMMdd"
                    currentDate = currentDate.addingTimeInterval(TimeInterval(-30*60*60*24))
                    self.deleteTrips(currentDate as Date)
                })
            }
            else{
                
                //Nếu là load ngày đang chọn
                if self.date == byDate{
                    
                    //Lấy dữ liệu từ local
                    self.arrTrip = [Trip]()
                    self.alert.hideView()
                    let jsonTrips = self.userDefaults.value(forKey: self.date) as? NSData
                    if jsonTrips != nil{
                        self.arrTrip = self.jsonHelper.parseTrips(jsonTrips! as Data)
                    }
                    self.collectionViewCatagory.reloadData()
                    if choose{
                        self.alert = SCLAlertView()
                        self.alert.showError("Lỗi!", subTitle: "Không có kết nối mạng!")
                        
                    }
                }
            }
        }
    }
    
    func timerTask() {
        if UIApplication.shared.applicationState == UIApplicationState.active{
            //            loadData(self.date, choose: false)
        }
    }
    
    //Hàm xoá dữ liệu
    func deleteTrips(_ tripDate: Date?){
        var dateDelete = tripDate! as Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        
        //Xoá trong vòng 30 ngày
        for _ in 1...31 {
            dateDelete = dateDelete.addingTimeInterval(TimeInterval(-24*60*60))
            let strDate = dateFormat.string(from: dateDelete)
            let dataJsonTrips = userDefaults.value(forKey: strDate) as? Data
            if dataJsonTrips != nil{
                let trips = self.jsonHelper.parseTrips(dataJsonTrips!)
                for trip in trips {
                    self.userDefaults.removeObject(forKey: trip.TripId)
                    self.userDefaults.synchronize()
                }
                self.userDefaults.removeObject(forKey: strDate)
                self.userDefaults.synchronize()
            }
        }
    }
    
    //Lưu dữ liệu của khách trong chuyến xuống local
    func insertCustomer(_ tripId: String, atDate: String){
        
        //Lấy dữ liệu từ server
        let soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetOrderByTrip><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:TripId>\(tripId)</tem:TripId><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:GetOrderByTrip></soapenv:Body></soapenv:Envelope>")
        let soapAction = "http://tempuri.org/IMobihomeWcf/GetOrderByTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            self.alert.hideView()
            
            //Có kết nối mạng
            if error == nil {
                
                //Có phản hồi từ server
                if string != "" {
                    
                    //Lấy danh sách khách hàng từ server
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    var jsonString = ""
                    var arrCustomers = self.jsonHelper.parseCustomers(data!)
                    let jsonHelper = JsonHelper()
                    
                    //Lấy danh sách cũ từ local
                    let oldData = self.userDefaults.value(forKey: tripId) as? NSData
                    
                    //Nếu tồn tại
                    if oldData != nil{
                        var oldCustomers = jsonHelper.parseCustomers(oldData! as Data)
                        
                        //Set biến đã đón, chưa đón cho danh sách mới
                        for i in 0 ..< arrCustomers.count{
                            for j in 0 ..< oldCustomers.count {
                                if oldCustomers[j].OrderGuid == arrCustomers[i].OrderGuid{
                                    arrCustomers[i].IsOnBus = oldCustomers[j].IsOnBus
                                }
                            }
                        }
                        
                        //Lưu dữ liệu danh sách mới xuống local
                        jsonString = self.jsonHelper.customersToJson(arrCustomers)
                        let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                        self.userDefaults.setValue(jsonData, forKey: tripId)
                        self.userDefaults.synchronize()
                    }
                        
                        //Nếu chưa từng lưu danh sách xuống local
                    else{
                        jsonString = self.jsonHelper.customersToJson(arrCustomers)
                        let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                        self.userDefaults.setValue(jsonData, forKey: tripId)
                        self.userDefaults.synchronize()
                        
                    }
                }
            }
            
        }
        
    }
    func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        if #available(iOS 8.0, *) {
//            let str = "\(DispatchQoS.QoSClass.userInitiated.rawValue)" as NSString
            DispatchQueue.global().async {
                if(background != nil){ background!(); }
                
                let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime) {
                    if(completion != nil){ completion!(); }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTrip.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewCatagory.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryViewCell
        let trip = arrTrip[(indexPath as NSIndexPath).row]
        cell.setData(trip: trip)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueFactory.fromCategoryToSchema.rawValue, sender: indexPath)
    }
    
    // MARK: - User Action
    
    @IBAction func btnChooseRouteClick(_ sender: Any) {
        isChooseRoute = true
        let dropDown = DropDown()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        dropDown.anchorView = btnDiemDi
        
        var arrDropDown = [String]()
        for route in routes {
            arrDropDown.append(route.Name)
        }

        dropDown.dataSource = arrDropDown
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnChooseRoute.setTitle(item, for: .normal)
            self.currentRoute = self.routes[index]
            self.collectionViewCatagory.reloadData()
        }
        dropDown.show()
    }
    
    @IBAction func rightButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        self.loadDanhSachXe(self.date, choose: true)
    }
    
    @IBAction func leftButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(-24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        self.loadDanhSachXe(self.date, choose: true)
    }
    
    @IBAction func selectDateButtonClick(_ sender: Any) {
        formatter.dateFormat = "yyyyMMdd"
        let datePicker = DatePickerDialog()
        datePicker.defaultDate = formatter.date(from: date)
        datePicker.show("Chọn ngày cần xem", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            self.formatter.dateFormat = "dd/MM/yyyy"
            self.dateLabel.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "yyyyMMdd"
            self.date = self.formatter.string(from: date)
            self.arrTrip = [Trip]()
            self.collectionViewCatagory.reloadData()
            self.alert = SCLAlertView()
            self.alert.showWait("Đang tải dữ liệu!", subTitle: "Vui lòng đợi!")
            self.loadDanhSachXe(self.date, choose: true)
        }
    }
    
    @IBAction func editRoute(_ sender: Any) {
        performSegue(withIdentifier: SegueFactory.fromCategoryToEditCategory.rawValue, sender: nil)
    }
    
    @IBAction func goToListGoods(_ sender: Any) {
       performSegue(withIdentifier: SegueFactory.fromCategoryToGoods.rawValue, sender: nil)
    }
    
    @IBAction func btnChonDiemDiClick(_ sender: Any) {
        loadDiaDiemDiLenDropDown()
    }
    
    @IBAction func btnChonDiemDenClick(_ sender: Any) {
        loadDiaDiemDenLenDropDown()
    }
}
