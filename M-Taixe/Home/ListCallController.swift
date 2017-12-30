//
//  ListCallController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/5/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class ListCallController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topbar: UIView!
    var currentPageNum = 1
    var currentPageSize = 20
    var isRecentCall = false
    var jsonHelper = JsonHelper()
    var alert = SCLAlertView()
    var sendPostRequest = SendPostRequest()
    var formatter = DateFormatter()
    var currentUser = User()
    var date = ""
    var inforView = false
    var calls = [Call]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        initUI()
        loadData()
    }
    
    // MARK: - Init Data
    
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
    
    func initUI() {
        tableView.allowsSelection = false
        //lấy ngày hiện tại
        formatter.dateFormat = "yyyyMMdd"
        let d = Date()
        date = formatter.string(from: d)
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: d)
        AppUtils.addShadowToView(view: topbar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calls.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        formatter.dateFormat = "yyyyMMdd"
        if isRecentCall{
            return "Hôm nay"
        }
        var currentDate = Date()
        currentDate = formatter.date(from: formatter.string(from: currentDate))!
        let chooseDate = formatter.date(from: date)
        let duration = chooseDate?.timeIntervalSince(currentDate)
        if duration == 0{
            return "Hôm nay"
        }
        if duration! == -24*60*60{
            return "Hôm qua"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return "Ngày \(dateFormatter.string(from: chooseDate!))"
    }
    
    func loadData() {
        self.alert = SCLAlertView()
        alert.showWait("Đang tải dữ liệu!", subTitle: "Vui lòng đợi")
        calls = [Call]()
        currentPageNum = 1
        currentPageSize = 20
        tableView.reloadData()
        if isRecentCall{
            loadRecentCall()
        }
        else {
            loadFilterCall()
        }
    }
    
    func loadFilterCall() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Calling_Filter>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:CallFrom>\(date)</tem:CallFrom>" +
            "<!--Optional:-->" +
            "<tem:CallTo>\(date)</tem:CallTo>" +
            "<!--Optional:-->" +
            "<tem:PageNumber>\(currentPageNum)</tem:PageNumber>" +
            "<!--Optional:-->" +
            "<tem:PageSize>\(currentPageSize)</tem:PageSize>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Calling_Filter>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Calling_Filter"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if error == nil{
                let arr = self.jsonHelper.parseCalls(result.data(using: String.Encoding.utf8)!)
                self.currentPageNum += 1
                self.currentPageSize = arr.count
                self.calls.append(contentsOf: arr)
                self.alert.hideView()
                self.tableView.reloadData()
                
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func loadRecentCall() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Calling_GetListRecent>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Calling_GetListRecent>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Calling_GetListRecent"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if error == nil{
                self.calls = self.jsonHelper.parseCalls(result.data(using: String.Encoding.utf8)!)
                self.alert.hideView()
                self.tableView.reloadData()
                
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    @IBAction func recentCallClick(_ sender: Any) {
        if isRecentCall{
            isRecentCall = false
        }
        else{
            isRecentCall = true
        }
        loadData()
    }
    
    @IBAction func rightClick(_ sender: Any) {
        isRecentCall = false
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        loadData()
    }
    
    @IBAction func leftClick(_ sender: Any) {
        isRecentCall = false
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(-24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
        loadData()
    }
    
    @IBAction func chooseDateClick(_ sender: Any) {
        isRecentCall = false
        formatter.dateFormat = "yyyyMMdd"
        let datePicker = DatePickerDialog()
        datePicker.defaultDate = formatter.date(from: date)
        datePicker.show("Chọn ngày cần xem", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            self.formatter.dateFormat = "dd/MM/yyyy"
            self.dateLabel.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "yyyyMMdd"
            self.date = self.formatter.string(from: date)
            self.loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let call = calls[indexPath.row]
        cell.lblCusName.text = call.CustomerName
        cell.lblCusMobile.text = call.PhoneNumber
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let callTime = dateFormatter.date(from: "\(call.CallAt)")
        
        dateFormatter.dateFormat = "HH:mm"
        cell.lblTime.text = dateFormatter.string(from: callTime!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == calls.count-1 && !isRecentCall {
            if currentPageSize >= 20{
                loadFilterCall()
            }
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
