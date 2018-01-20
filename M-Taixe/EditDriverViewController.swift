//
//  EditDriverViewController.swift
//  M-Taixe
//
//  Created by M on 1/14/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit

class EditDriverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bienSoLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var driverTableView: UITableView!
    @IBOutlet weak var topBarMenu: UIView!
    
    var trip = Trip()
    var currentUser = User()
    var pageNumber: Int = 1
    var pageSize: Int = 50
    var employees = [Employee]()
    var alert = SCLAlertView()
    var jsonHelper = JsonHelper()
    var Driver1Id: Int = 0
    var Employee1Id: Int = 0
    var employeeByTrip = EmployeeByTrip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
        getDriverByTrip()
        getEmployee(positionId: 1, searchText: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initData(trip: Trip) {
        self.trip = trip
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
        bienSoLabel.text = trip.LicensePlate
        startTimeLabel.text = trip.StartTime
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
         AppUtils.addShadowToView(view: topBarMenu, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    func segmentedControlValueChanged() {
        if segmentControl.selectedSegmentIndex == 0 {
            getEmployee(positionId: 1, searchText: "")
        } else {
            getEmployee(positionId: 2, searchText: "")
        }
    }
    
    // MARK:  - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeViewCell", for: indexPath) as! DriverViewCell
        DispatchQueue.main.async {
            cell.selectionStyle = .none
            let data = self.employees[indexPath.row]
            cell.setDataToView(employee: data, index: indexPath.row, employeeByTrip: self.employeeByTrip)
            cell.delegate = self
        }
        return cell
    }
    
    // MARK: - User Action
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        changeEmployee(Driver1Id: Driver1Id, Employee1Id: Employee1Id)
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
    }
    
    // MAKR: Get API
    
    func getEmployee(positionId: Int, searchText: String) {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_DriverForChange>" +
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
            "<tem:SearchText>\(searchText)</tem:SearchText>" +
            "<!--Optional:-->" +
            "<tem:PositionID>\(positionId)</tem:PositionID>" +
            "<!--Optional:-->" +
            "<tem:pageNumber>\(pageNumber)</tem:pageNumber>" +
            "<!--Optional:-->" +
            "<tem:pageSize>\(pageSize)</tem:pageSize>" +
            "</tem:Trip_DriverForChange>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_DriverForChange"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                DispatchQueue.main.async {
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.employees = self.jsonHelper.parseEmployee(data!)
                    self.driverTableView.reloadData()
                }
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func changeEmployee(Driver1Id: Int, Employee1Id: Int) {
        if Driver1Id == 0 && Employee1Id == 0 {
            return
        }
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_EmployeeSelected>" +
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
            "<tem:TripId>\(trip.TripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:Driver1Id>\(Driver1Id)</tem:Driver1Id>" +
            "<!--Optional:-->" +
            "<tem:Employee1Id>\(Employee1Id)</tem:Employee1Id>" +
            "</tem:Trip_EmployeeSelected>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_EmployeeSelected"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
               self.navigationController?.popViewController(animated: true)
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    func getDriverByTrip() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetEmployeesByTrip>" +
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
            "<tem:TripId>\(trip.TripId)</tem:TripId>" +
            "</tem:Trip_GetEmployeesByTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetEmployeesByTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){ (string, error) in
            if error == nil {
                let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                self.employeeByTrip = self.jsonHelper.parseEmployeeByTrip(data!)
                self.Employee1Id = self.employeeByTrip.Employee1Id
                self.Driver1Id = self.employeeByTrip.Driver1Id
            }
            else {
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
}

extension EditDriverViewController: CheckBoxDelegate {
    func checkCheckBox(indexCheckBox: Int) {
        if segmentControl.selectedSegmentIndex == 0 {
            Driver1Id = employees[indexCheckBox].EmployeeId
        } else {
            Employee1Id = employees[indexCheckBox].EmployeeId
        }
        
//        DispatchQueue.main.async {
//            for row in 0 ..< self.employees.count {
//                if row != indexCheckBox {
//                    let cell = self.driverTableView.cellForRow(at: IndexPath(item: row, section: 0)) as! DriverViewCell
//                    cell.checkBox.isSelected = false
//                }
//            }
//        }
        
//         self.driverTableView.reloadData()
    }
}

