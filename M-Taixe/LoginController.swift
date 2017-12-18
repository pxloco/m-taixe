//
//  LoginController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    //Khai báo biến là các UI
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ẩn navigationbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tfUserName.layer.cornerRadius = 0
        tfPassword.layer.cornerRadius = 0
        btnLogin.layer.cornerRadius = 20
        navigateToTrip()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tfUserName.delegate = self
        tfPassword.delegate = self
    }
    func navigateToTrip(){
        //Lấy tên đăng nhập từ local
        let defaults = UserDefaults.standard
        
        let userName = defaults.value(forKey: "UserName")
        let password = defaults.value(forKey: "Password")
        let displayName = defaults.value(forKey: "FullName")
        let roleType = defaults.value(forKey: "RoleType")
        let companyId = defaults.value(forKey: "CompanyId")
        let AgentId = defaults.value(forKey: "AgentId")
        let userId = defaults.value(forKey: "UserId")
        let userGuid = defaults.value(forKey: "UserGuid")
        
        //Nếu đã đăng nhập rồi chuyển sang trang xem danh sách chuyến
        if userName != nil {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let controller = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryController

            controller.currentUser.UserName = userName  as! String
            controller.currentUser.Password = password as! String
            controller.currentUser.DisplayName = displayName  as! String
            controller.currentUser.RoleType = Int.init(roleType as! String)!
            controller.currentUser.CompanyId = companyId  as! String
            controller.currentUser.AgentId = AgentId as! String
            controller.currentUser.UserId = userId  as! String
            controller.currentUser.UserGuid = userGuid as! String
            self.navigationController?.pushViewController(controller, animated: false)
        }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        if textField.placeholder == "Mật khẩu" {
            btnLoginClick(btnLogin)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dismissKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var alert = SCLAlertView()
    @IBAction func btnLoginClick(_ sender: UIButton) {
        let userName = self.tfUserName.text ?? ""
        let password = self.tfPassword.text ?? ""
        if userName == "" {
            alert = SCLAlertView()
            alert.showError("Cảnh báo!", subTitle: "Bạn phải nhập số điện thoại!")
            return
        }
        if password == "" {
            alert = SCLAlertView()
            alert.showError("Cảnh báo!", subTitle: "Bạn phải nhập mật khẩu!")
            return
        }
        //Hiện thông báo
        alert = SCLAlertView()
        alert.showWait("Vui lòng đợi!", subTitle: "Đang kết nối! Vui lòng đợi giây lát.")
        
        let soapMessage = String(format: "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:SiteLogInV2><!--Optional:--><tem:UserName>%@</tem:UserName><!--Optional:--><tem:Password>%@</tem:Password><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:SiteLogInV2></soapenv:Body></soapenv:Envelope>",tfUserName.text!, tfPassword.text! )
        let soapAction = "http://tempuri.org/IMobihomeWcf/SiteLogInV2"
        let sendPost = SendPostRequest()
        
        //Gửi yêu cầu đăng nhập lên web service
        sendPost.sendRequest(soapMessage, soapAction: soapAction, callBack: { (string, error) in
            if error == nil{
                if string != ""{
                    var arr = string.components(separatedBy: "\t")
                    //Kết quả server trả về là true thì lưu thông tin tài khoản xuống bộ nhớ local, chuyển sang view sau
                    if arr[0] == "true"{
                        self.alert.hideView()
                        let defaults = UserDefaults.standard
                        defaults.setValue("\(userName)", forKey: "UserName")
                        defaults.setValue("\(password)", forKey: "Password")
                        defaults.setValue("\(arr[1])", forKey: "FullName")
                        defaults.setValue("\(arr[2])", forKey: "RoleType")
                        defaults.setValue("\(arr[3])", forKey: "CompanyId")
                        defaults.setValue("\(arr[4])", forKey: "AgentId")
                        defaults.setValue("\(arr[5])", forKey: "UserId")
                        defaults.setValue("\(arr[6])", forKey: "UserGuid")
                        defaults.synchronize()
                        let u = String(describing: defaults.value(forKey: "UserName"))
                        self.navigateToTrip()
                    }
                        
                    //Kết quả trả về là false
                    else{
                        self.alert.hideView()
                        self.alert = SCLAlertView()
                        self.alert.showError("Lỗi!", subTitle: "Tài khoản hoặc mật khẩu không đúng!")
                    }
                }    //Lỗi ở server
                else
                {
                    self.alert.hideView()
                    self.alert = SCLAlertView()
                    self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
                }
            }
                //Không có internet
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không có kết nối internet!")
            }
        })
        
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
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
