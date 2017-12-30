//
//  AnalysViewController.swift
//  M-Taixe
//
//  Created by M on 12/17/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class AnalysViewController: UIViewController {

    var currentUser = User()
    var userDefaults = UserDefaults.standard
    var formatter = DateFormatter()
    var date = ""
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var topbar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    // MARK: - Init
    func initData() {
        //lấy ngày hiện tại
        formatter.dateFormat = "yyyyMMdd"
        let d = Date()
        date = formatter.string(from: d)
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: d)
        AppUtils.addShadowToView(view: topbar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
    
    // MARK: - User Action
    
    @IBAction func selectDateClick(_ sender: Any) {
        formatter.dateFormat = "yyyyMMdd"
        let datePicker = DatePickerDialog()
        datePicker.defaultDate = formatter.date(from: date)
        datePicker.show("Chọn ngày cần xem", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            self.formatter.dateFormat = "dd/MM/yyyy"
            self.dateLabel.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "yyyyMMdd"
            self.date = self.formatter.string(from: date)
        }
    }
    
    @IBAction func rightDateButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
    }
    
    @IBAction func leftDateButtonClick(_ sender: Any) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd"
        var current = dateFormat.date(from: self.date)
        current = current?.addingTimeInterval(TimeInterval(-24*60*60))
        self.date = dateFormat.string(from: current!)
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormat.string(from: current!)
    }
    
    @IBAction func btnThongKeTheoXeClick(_ sender: Any) {
    }
    
}
