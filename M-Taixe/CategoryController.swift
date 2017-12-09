//
//  CategoryController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import HPXibDesignable
import HPUIViewExtensions

class CategoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contrainsButton: NSLayoutConstraint!
    @IBOutlet weak var btnChooseRoute: HPButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("role type: \(currentUser.RoleType)")
        if currentUser.RoleType == 1 {
            contrainsButton.constant = contrainsButton.constant-btnChooseRoute.frame.size.height
            btnChooseRoute.isHidden = true
        }
        
        initUI()
                tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        alert.showWait("Đang tải dữ liệu!", subTitle: "Vui lòng đợi!")
        if currentUser.RoleType != 1 {
            loadRoute()
        }
        else{
            //Load dữ liệu
            loadData(date, choose: true)
        }
        
        
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
    
    // - MARK: Init
    
    func initUI() {
        let fullName = self.userDefaults.value(forKey: "FullName") as! String
        self.nameLabel.text = "\(fullName)   "
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        //Thêm các nút tác vụ vào toolbar
        let inforButton = UIBarButtonItem.init(image: UIImage(named: "person-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoryController.btnInforClick(_:)))
        let listButton = UIBarButtonItem.init(image: UIImage(named: "ListIcon"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        listButton.tintColor = UIColor(netHex: 0x197DAE)
        inforButton.tintColor = UIColor(netHex: 0x555555)
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        if currentUser.RoleType != 1 {
            let listCallButton = UIBarButtonItem.init(image: UIImage(named: "phone_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnListCallClick))
            
            listCallButton.tintColor = UIColor(netHex: 0x555555)
            let items = [flex,listButton,flex,listCallButton, flex, inforButton, flex]
            self.toolbarItems = items
        }
        else{
            
            let items = [flex,listButton,flex, inforButton, flex]
            self.toolbarItems = items
        }
        
        //lấy ngày hiện tại
        formatter.dateFormat = "yyyyMMdd"
        let d = Date()
        date = formatter.string(from: d)
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: d)
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
        //print(soapMessage)
        let soapAction = "http://tempuri.org/IMobihomeWcf/Route_GetForBooking"
        var sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                self.routes = self.jsonHelper.parseRoutes(data!)
                if self.routes.count>0{
                    self.currentRoute = self.routes[0]
                    self.btnChooseRoute.setTitle(self.currentRoute.Name, for: UIControlState.normal)
                    print("routeid: \(self.currentRoute.RouteId)")
                    
                    //Load dữ liệu
                    self.loadData(self.date, choose: true)
                }
                else{
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
    
    @IBAction func btnChooseRouteClick(_ sender: Any) {
        isChooseRoute = true
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ChooseRoute") as! ChooseRouteController
        controller.routes = self.routes
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func timerTask(){
        if UIApplication.shared.applicationState == UIApplicationState.active{
            loadData(self.date, choose: false)
            
        }
    }
    func btnListCallClick(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListCall") as! ListCallController
        controller.currentUser = self.currentUser
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //Button xem thông tin tk
    func btnInforClick(_ sender: UIBarButtonItem){
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListCall") as! ListCallController
        controller.currentUser = self.currentUser
        controller.inforView = true
        self.navigationController?.pushViewController(controller, animated: false)

    }
    
    //Hàm load dữ liệu
    func loadData(_ byDate: String, choose: Bool){
        var soapMessage = String()
        var soapAction = ""
        if currentUser.RoleType == 1{
            soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:TripDriver_GetByDate><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:TripDate>\(byDate)</tem:TripDate><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:TripDriver_GetByDate></soapenv:Body></soapenv:Envelope>")
            soapAction = "http://tempuri.org/IMobihomeWcf/TripDriver_GetByDate"
        }
        else{
            soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
                "<soapenv:Header/>" +
                "<soapenv:Body>" +
                "<tem:Trip_GetForBooking>" +
                "<!--Optional:-->" +
                "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
                "<!--Optional:-->" +
                "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
                "<!--Optional:-->" +
                "<tem:Password>\(currentUser.Password)</tem:Password>" +
                "<!--Optional:-->" +
                "<tem:SelectDate>\(byDate)</tem:SelectDate>" +
                "<!--Optional:-->" +
                "<tem:RouteId>\(currentRoute.RouteId)</tem:RouteId>" +
                "<!--Optional:-->" +
                "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
                "</tem:Trip_GetForBooking>" +
                "</soapenv:Body>" +
            "</soapenv:Envelope>"
            print(soapMessage)
            soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetForBooking"
        }
        
        var sendPostRequest = SendPostRequest()
        
        //Gửi yêu cầu lấy danh sách chuyến trong ngày "bydate"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            if error == nil {
                
                //Parse dữ liệu trả về sang NSData
                var data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                var trips = [Trip]()
                
                //Chuyển sang danh sách chuyến
                trips = self.jsonHelper.parseTrips(data!)
                
                //Nếu có dữ liẹu trả về từ server thì lưu xuống bộ nhớ local
                if string != ""{
                    self.userDefaults.setValue(data, forKey: byDate)
                    self.userDefaults.synchronize()
                }
                
                //Nếu là load ngày dc chọn
                if self.date == byDate{
                    self.arrTrip = [Trip]()
                    self.alert.hideView()
                    
                    //Nếu ko nhận dc dữ liệu từ server (server lỗi)
                    if string == ""{
                        if choose{
                            self.alert = SCLAlertView()
                            self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
                        }
                        //Lấy danh sách chuyến từ local
                        var jsonTrips = self.userDefaults.value(forKey: self.date) as? NSData
                        if jsonTrips != nil{
                            self.arrTrip = self.jsonHelper.parseTrips(jsonTrips! as Data)
                        }
                        self.tableView.reloadData()
                    }
                    else{
                        
                        //Load dữ liệu của server trả về
                        self.arrTrip = trips
                        self.tableView.reloadData()
                    }
                }
                
                //Chạy ngầm tính năng lưu dữ liệu xuống local
                self.backgroundThread(0.0, background: {
                    
                    //Lưu danh sách khách hàng của từng chuyến
                    for i in 0 ..< trips.count {
                        var trip = trips[i]
                        self.insertCustomer(trip.TripId, atDate: byDate)
                    }
                    
                    //Xoá dữ liệu cách đây 30ngày
                    var currentDate = NSDate()
                    var dateFormat = DateFormatter()
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
                    var jsonTrips = self.userDefaults.value(forKey: self.date) as? NSData
                    if jsonTrips != nil{
                        self.arrTrip = self.jsonHelper.parseTrips(jsonTrips! as Data)
                    }
                    self.tableView.reloadData()
                    if choose{
                        self.alert = SCLAlertView()
                        self.alert.showError("Lỗi!", subTitle: "Không có kết nối mạng!")
                        
                    }
                }
            }
        }
    }
    
    //Hàm xoá dữ liệu
    func deleteTrips(_ tripDate: Date?){
        var dateDelete = tripDate! as Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        
        //Xoá trong vòng 30 ngày
        for i in 1...31 {
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
        var sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            self.alert.hideView()
            
            //Có kết nối mạng
            if error == nil{
                
                //Có phản hồi từ server
                if string != ""{
                    
                    //Lấy danh sách khách hàng từ server
                    var data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    var jsonString = ""
                    var arrCustomers = self.jsonHelper.parseCustomers(data!)
                    var jsonHelper = JsonHelper()
                    
                    //Lấy danh sách cũ từ local
                    var oldData = self.userDefaults.value(forKey: tripId) as? NSData
                    
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
            var str = "\(DispatchQoS.QoSClass.userInitiated.rawValue)" as NSString
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Danh sách chuyến"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTrip.count
    }
   
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("top")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Customers") as! CustomersController
        controller.currentUser = self.currentUser
        controller.tripId = arrTrip[(indexPath as NSIndexPath).row].TripId
        controller.gioXuatBen = arrTrip[(indexPath as NSIndexPath).row].StartTime
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let trip = arrTrip[(indexPath as NSIndexPath).row]
        cell.lblTime.text = trip.StartTime
        let choTrong = trip.CountTicket - trip.CountBooked
        cell.lblBX.text = "\(trip.LicensePlate) \(choTrong)/\(trip.CountTicket)"
        return cell
        
    }
    
    @IBAction func rightButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        loadData(self.date, choose: true)
    }
    
    @IBAction func leftButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(-24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        loadData(self.date, choose: true)
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
            self.tableView.reloadData()
            self.alert = SCLAlertView()
            self.alert.showWait("Đang tải dữ liệu!", subTitle: "Vui lòng đợi!")
            self.loadData(self.date, choose: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.overTop = false
        tableView.reloadData()
        if isChooseRoute{
            btnChooseRoute.setTitle(currentRoute.Name, for: UIControlState.normal)
            self.loadData(date, choose: true)
        }
    }
    var overTop = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y < -30{
                overTop = true
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if overTop{
            //navigateToSearch()
        }
    }
    func navigateToSearch(){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)

        var storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        var controller = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchController
        controller.currentUser = self.currentUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
