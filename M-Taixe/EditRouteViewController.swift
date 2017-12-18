//
//  EditRouteViewController.swift
//  M-Taixe
//
//  Created by M on 12/16/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class EditRouteViewController: UIViewController {
    
    @IBOutlet weak var txtPhuongTien: UITextField!
    @IBOutlet weak var txtTuyen: UITextField!
    @IBOutlet weak var txtGiaVe: UITextField!
    @IBOutlet weak var switchBanOnline: UISwitch!
    @IBOutlet weak var txtTaiXe: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtDtChuyen: UITextField!
    @IBOutlet weak var txtBienSo: UITextField!
    @IBOutlet weak var switchCoGhe: UISwitch!
    @IBOutlet weak var switchChoDaiLyBan: UISwitch!
    @IBOutlet weak var switchChoDatCoc: UISwitch!
    @IBOutlet weak var switchGioiHanNguoiBan: UISwitch!
    @IBOutlet weak var switchLuuTru: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 1000)
    }
    
    // MARK: - User Action
    
    @IBAction func btnGioXuatPhat(_ sender: Any) {
    }
    
    @IBAction func btnHuyChuyen(_ sender: Any) {
    }
    
    @IBAction func btnHuy(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLuu(_ sender: Any) {
    }
}
