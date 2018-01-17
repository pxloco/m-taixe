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
    
    var formatter = DateFormatter()
    
    func setData(trip: Trip) {
        formatter.dateFormat = "yyyyMMddHHmm"
        if let currentTime = formatter.date(from: formatter.string(from: Date())) {
            if let startTime = formatter.date(from: trip.StartTimeFull) {
                if let endTime  = formatter.date(from: trip.EndTime) {
                    if currentTime > endTime {
                        imageTrangThai.image = #imageLiteral(resourceName: "circle_red_icon")
                    } else if currentTime < startTime {
                        imageTrangThai.image = #imageLiteral(resourceName: "circle_green_icon")
                    } 
                }
            }
        }
        
        if trip.CountBooked == trip.CountTicket {
            progressView.botRightRounded = true
            progressView.topRightRounded = true
        } else {
            progressView.botRightRounded = false
            progressView.topRightRounded = false
        }
        
        if (trip.BillFreightCount - trip.BillFreightPaidCount) == 0 {
            goodsNotPaidview.isHidden = true
        } else {
            goodsNotPaidview.isHidden = false
            countGoodsNotPaidLabel.text = "\(trip.BillFreightCount - trip.BillFreightPaidCount)"
        }
        
        if (trip.CountBooked - trip.CountPaid) == 0 {
            soVeChuaTienView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            soVeChuaTienView.borderWidth = 0
        } else {
            soVeChuaTienView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            soVeChuaTienView.borderWidth = 1
        }
        
        let widthProgressBar = soLuongVeView.bounds.width
        let choTrong = trip.CountTicket - trip.CountBooked
        labelBienSo.text = "\(trip.LicensePlate)"
        labelGioXuatBen.text = trip.StartTime
        
        backgroundCategory.backgroundColor = AppUtils.hexStringToUIColor(hex: trip.color)
        soVeChuaTien.text = "\(trip.CountBooked - trip.CountPaid) CT"
 
        if trip.CountBooked == 0 && trip.CountTicket == 0 {
             widthProgressConstraint.constant  = 0
            labelTrangThaiBanVe.text = "Chưa  bán vé"
            imageTrangThai.image = #imageLiteral(resourceName: "play_icon")
        } else {
            widthProgressConstraint.constant = (CGFloat(trip.CountBooked)/CGFloat(trip.CountTicket)) * CGFloat(widthProgressBar)
            labelTrangThaiBanVe.text = "Còn trống \(choTrong)/\(trip.CountTicket)"
        }
    }
}
