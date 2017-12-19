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
    
    func setData(trip: Trip) {
        let choTrong = trip.CountTicket - trip.CountBooked
        labelBienSo.text = "\(trip.LicensePlate) \(choTrong)/\(trip.CountTicket)"
        labelGioXuatBen.text = trip.StartTime
        labelTrangThaiBanVe.text = String(trip.CountTicket - trip.CountBooked)
    }
}
