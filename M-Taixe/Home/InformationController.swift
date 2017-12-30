//
//  InformationController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/18/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class InformationController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentUser = User()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    var userDefaults = UserDefaults.standard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InformationCell") as! InformationCell
        if (indexPath as NSIndexPath).section == 0{
            if (indexPath as NSIndexPath).row == 0{
                cell.btnLogout.removeFromSuperview()
                let tel = userDefaults.value(forKey: "UserName") as! String
                cell.lblInfor.text = tel
                cell.imgView.image = UIImage(named: "callicon")
            }
            else{
                cell.btnLogout.removeFromSuperview()
                let tel = userDefaults.value(forKey: "FullName") as! String
                cell.lblInfor.text = tel
                cell.imgView.image = UIImage(named: "user_icon")
            }
        }
        else{
            cell.lblInfor.removeFromSuperview()
            cell.imgView.removeFromSuperview()
            cell.btnLogout.addTarget(self, action: #selector(InformationController.btnLogoutClick(_:)), for: UIControlEvents.touchUpInside)
        }
        return cell
    }
    
    func btnLogoutClick(_ sender:  UIButton){
        self.userDefaults.removeObject(forKey: "UserName")
        self.userDefaults.removeObject(forKey: "Password")
        self.userDefaults.removeObject(forKey: "FullName")
        self.userDefaults.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Thông tin tài khoản"
            
        }
        return ""
    }
}
