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
        let defaults = UserDefaults.standard
        let userName = defaults.value(forKey: "UserName")

        if userName != nil {
            performSegue(withIdentifier: SegueFactory.fromLoginToHomeTabBar.rawValue, sender: nil)
        }
    }
    
    func dismissKeyboard() {
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
                    if arr[0] == "true" {
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
                        
                        let devideId = UIDevice.current.identifierForVendor!.uuidString
                        if devideId != "" {
                            defaults.setValue("\(devideId)", forKey: "DevideId")
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyymmddHHmmss"
                            let d = Date()
                            let date = formatter.string(from: d)
                            let session = devideId + "-" + date
                            defaults.setValue("\(session)", forKey: "Session")
                        }
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
    }
}
