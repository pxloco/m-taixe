//
//  AddFretController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 10/12/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import HPUIViewExtensions

class AddFretController: UIViewController {

    @IBOutlet weak var tfConsigneeAdd: UITextField!
    @IBOutlet weak var tfShipperAdd: UITextField!
    @IBOutlet weak var tfCost: UITextField!
    @IBOutlet weak var tfBillName: UITextField!
    @IBOutlet weak var tfConsigneeName: UITextField!
    @IBOutlet weak var tfConsigneeMobile: UITextField!
    @IBOutlet weak var tfShipperName: UITextField!
    @IBOutlet weak var tfShipperMobile: UITextField!
    @IBOutlet weak var topBarMenu: UIView!
    @IBOutlet weak var groupName: UIView!
    @IBOutlet weak var groupConsignee: UIView!
    @IBOutlet weak var groupShipper: UIView!
    @IBOutlet weak var daThanhToanCheckbox: UICheckbox!
    @IBOutlet weak var deleteGoodsButton: HPButton!
    
    var billID = 0
    var tripId = ""
    var bill = Bill()
    var currentUser = User()
    var alert = SCLAlertView()
    var sendPostRequest = SendPostRequest()
    var jsonHelper = JsonHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if billID != 0{
            tfShipperName.text = bill.ShipperName
            tfShipperAdd.text = bill.ShipperAdd
            tfShipperMobile.text = bill.ShipperMobile
            tfConsigneeAdd.text = bill.ConsigneeAdd
            tfConsigneeName.text = bill.Consignee
            tfConsigneeMobile.text = bill.ConsigneeMobile
            tfCost.text = "\(bill.TotalCharges)"
            tfBillName.text = bill.NameOfGoods
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    func setUpData(tripId: String) {
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
    }
    
    func setUpUI() {
        AppUtils.addShadowToView(view: topBarMenu, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
        if billID == 0 {
            deleteGoodsButton.isHidden = true
        } else {
            deleteGoodsButton.isHidden = false
        }
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func btnCancelClick(){
        self.navigationController?.popViewController(animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    
    // MARK: - User Action
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func saveAction(_ sender: Any) {
        btnSaveClick()
    }
    
    @IBAction func deleteGoodsAction(_ sender: Any) {
        deleteGoods()
    }
    
    // MARK: Get API
    
    func btnSaveClick() {
        let billName = tfBillName.text ?? ""
        let shipperName = tfShipperName.text ?? ""
        let shipperMobile = tfShipperMobile.text ?? ""
        let shipperAdd = tfShipperAdd.text ?? ""
        let consigneeName = tfConsigneeName.text ?? ""
        let consigneeMobile = tfConsigneeMobile.text ?? ""
        let consigneeAdd = tfConsigneeAdd.text ?? ""
        let cost = tfCost.text ?? ""
        let IsPaid = daThanhToanCheckbox.isSelected
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:BillFreight_SaveV2>" +
            "<!--Optional:-->" +
            "<tem:BillId>\(billID)</tem:BillId>" +
            "<!--Optional:-->" +
            "<tem:LastAgentID>\(currentUser.AgentId)</tem:LastAgentID>" +
            "<!--Optional:-->" +
            "<tem:BillCode>-1</tem:BillCode>" +
            "<!--Optional:-->" +
            "<tem:ShipperName>\(shipperName)</tem:ShipperName>" +
            "<!--Optional:-->" +
            "<tem:ShipperPassport>-1</tem:ShipperPassport>" +
            "<!--Optional:-->" +
            "<tem:ShipperMobile>\(shipperMobile)</tem:ShipperMobile>" +
            "<!--Optional:-->" +
            "<tem:ShipperAdd>\(shipperAdd)</tem:ShipperAdd>" +
            "<!--Optional:-->" +
            "<tem:Consignee>\(consigneeName)</tem:Consignee>" +
            "<!--Optional:-->" +
            "<tem:ConsigneePassport>-1</tem:ConsigneePassport>" +
            "<!--Optional:-->" +
            "<tem:ConsigneeMobile>\(consigneeMobile)</tem:ConsigneeMobile>" +
            "<!--Optional:-->" +
            "<tem:ConsigneeAdd>\(consigneeAdd)</tem:ConsigneeAdd>" +
            "<!--Optional:-->" +
            "<tem:NameOfGoods>\(billName)</tem:NameOfGoods>" +
            "<!--Optional:-->" +
            "<tem:Description></tem:Description>" +
            "<!--Optional:-->" +
            "<tem:TotalGrossWeight>-1</tem:TotalGrossWeight>" +
            "<!--Optional:-->" +
            "<tem:TotalNetWeight>-1</tem:TotalNetWeight>" +
            "<!--Optional:-->" +
            "<tem:TotalMesurement>-1</tem:TotalMesurement>" +
            "<!--Optional:-->" +
            "<tem:TotalDeclareValue>-1</tem:TotalDeclareValue>" +
            "<!--Optional:-->" +
            "<tem:TotalAmounOfinsurance>-1</tem:TotalAmounOfinsurance>" +
            "<!--Optional:-->" +
            "<tem:TotalCharges>\(cost)</tem:TotalCharges>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:IsPaid>\(IsPaid)</tem:IsPaid>" +
            "<!--Optional:-->" +
            "<tem:ShipInOption>-1</tem:ShipInOption>" +
            "<!--Optional:-->" +
            "<tem:ShipOutOption>-1</tem:ShipOutOption>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:BillFreight_SaveV2>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IBillWcf/BillFreight_SaveV2"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction, urlKey:
        .billURL){
            (result, error) in
            if error == nil{
                self.alert.showSuccess("Thành công", subTitle: "Lưu phiếu hàng thành công!")
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    
    func deleteGoods() {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:SetDelete>" +
            "<!--Optional:-->" +
            "<tem:BillId>\(billID)</tem:BillId>" +
            "<!--Optional:-->" +
            "<tem:IsDeleted>true</tem:IsDeleted>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Name>\(currentUser.DisplayName)</tem:Name>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:SetDelete>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IBillWcf/SetDelete"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction, urlKey:
        .billURL){
            (result, error) in
            if error == nil{
                self.alert.showSuccess("Thành công", subTitle: "Xoá hàng thành công!")
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
