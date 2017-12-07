//
//  SearchController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/11/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import HPXibDesignable
import HPUIViewExtensions

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var arrCustomers = [Customer]()
    var currentUser = User()
    var currentPageNum = 1
    var currentPageSize = 20
    var sendPostRequest = SendPostRequest()
    var jsonHelper = JsonHelper()
    var alert = SCLAlertView()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: HPTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func initUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    func search(text: String){
        var soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Order_FastSearch>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SearchText>\(text)</tem:SearchText>" +
            "<!--Optional:-->" +
            "<tem:PageNumber>\(currentPageNum)</tem:PageNumber>" +
            "<!--Optional:-->" +
            "<tem:PageSize>20</tem:PageSize>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Order_FastSearch>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        var soapAction = "http://tempuri.org/IMobihomeWcf/Order_FastSearch"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) {
            (result, error) in
            if error == nil{
                var customers = self.jsonHelper.parseCustomers(result.data(using: String.Encoding.utf8)!)
                self.currentPageNum += 1
                self.currentPageSize = customers.count
                self.arrCustomers.append(contentsOf: customers)
                self.tableView.reloadData()
                self.alert.hideView()
                
            }
            else{
                if self.currentPageNum == 1{
                    self.alert.hideView()
                    self.alert = SCLAlertView()
                    self.alert.showError("Lỗi!", subTitle: "Không kết nối được server! Kiểm tra kết nối mạng!")
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchClick(_ sender: Any) {
        var searchText = searchTextField.text ?? ""
        if searchText != "" {
            
            alert = SCLAlertView()
            alert.showWait("Đang tải dữ liệu!", subTitle: "Vui lòng đợi!")
            currentPageNum = 1
            arrCustomers = [Customer]()
            tableView.reloadData()
            search(text: searchText)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrCustomers.count
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrCustomers.count-1 {
            if currentPageSize >= 20{
                var text = searchTextField.text ?? ""
                if text != ""{
                    search(text: text)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddOrder") as! AddOrderController
        controller.orderGuid = arrCustomers[indexPath.row].OrderGuid
        controller.currentOrder = arrCustomers[indexPath.row]
        controller.isSearch = true
        self.navigationController?.pushViewController(controller, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell") as! CustomerCell
            let customer = arrCustomers[(indexPath as NSIndexPath).row]
            cell.lblCustomerName.text = customer.CustomerName
            cell.lblCustomerNumber.text = customer.CustomerMobile
            cell.lblCatchAddress.text = customer.CatchAddress
        
        return cell
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
