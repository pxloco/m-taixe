//
//  CategoryViewCell.swift
//  M-Taixe
//
//  Created by M on 12/19/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit
import HPXibDesignable
import HPUIViewExtensions

class CategoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundCategory: HPView!
    @IBOutlet weak var labelBienSo: UILabel!
    @IBOutlet weak var labelTrangThaiBanVe: UILabel!
    @IBOutlet weak var labelGioXuatBen: UILabel!
    @IBOutlet weak var soVeChuaTien: UILabel!
    @IBOutlet weak var soVeChuaTienView: HPView!
    @IBOutlet weak var imageTrangThai: UIImageView!
    @IBOutlet weak var widthProgressConstraint: NSLayoutConstraint!
    @IBOutlet weak var soLuongVeView: HPView!
    @IBOutlet weak var progressView: HPView!
    @IBOutlet weak var goodsNotPaidview: HPView!
    @IBOutlet weak var countGoodsNotPaidLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    
    var formatter = DateFormatter()
    
    func setData(trip: Trip) {
        DispatchQueue.main.async {
            self.formatter.dateFormat = "yyyyMMddHHmm"
            if let currentTime = self.formatter.date(from: self.formatter.string(from: Date())) {
                if let startTime = self.formatter.date(from: trip.StartTimeFull) {
                    if let endTime  = self.formatter.date(from: trip.EndTime) {
                        if currentTime > endTime {
                            self.imageTrangThai.image = #imageLiteral(resourceName: "circle_red_icon")
                        } else if currentTime < startTime {
                            self.imageTrangThai.image = #imageLiteral(resourceName: "circle_green_icon")
                        }
                    }
                }
            }
            
            if trip.CountBooked == trip.CountTicket {
                self.progressView.botRightRounded = true
                self.progressView.topRightRounded = true
            } else {
                self.progressView.botRightRounded = false
                self.progressView.topRightRounded = false
            }
            
            if (trip.BillFreightCount - trip.BillFreightPaidCount) == 0 {
                self.goodsNotPaidview.isHidden = true
            } else {
                self.goodsNotPaidview.isHidden = false
                self.countGoodsNotPaidLabel.text = "\(trip.BillFreightCount - trip.BillFreightPaidCount)"
            }
            
            if (trip.CountBooked - trip.CountPaid) == 0 {
                self.soVeChuaTienView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.soVeChuaTienView.borderWidth = 0
            } else {
                self.soVeChuaTienView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                self.soVeChuaTienView.borderWidth = 1
            }
            
            let widthProgressBar = self.soLuongVeView.bounds.width
            let choTrong = trip.CountTicket - trip.CountBooked
            self.labelBienSo.text = "\(trip.LicensePlate)"
            self.labelGioXuatBen.text = trip.StartTime
            self.driverNameLabel.text = trip.DriversName
            
            self.backgroundCategory.backgroundColor = AppUtils.hexStringToUIColor(hex: trip.color)
            self.soVeChuaTien.text = "\(trip.CountBooked - trip.CountPaid) CT"
            
            if trip.CountBooked == 0 && trip.CountTicket == 0 {
                self.widthProgressConstraint.constant  = 0
                self.labelTrangThaiBanVe.text = "Chưa  bán vé"
                self.imageTrangThai.image = #imageLiteral(resourceName: "play_icon")
            } else {
                self.widthProgressConstraint.constant = (CGFloat(trip.CountBooked)/CGFloat(trip.CountTicket)) * CGFloat(widthProgressBar)
                self.labelTrangThaiBanVe.text = "Còn trống \(choTrong)/\(trip.CountTicket)"
            }
        }
    }
}
