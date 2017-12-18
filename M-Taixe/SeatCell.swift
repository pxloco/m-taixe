//
//  SeatCell.swift
//  M-Taixe
//
//  Created by M on 12/11/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class SeatCell: UICollectionViewCell {
    
    @IBOutlet weak var seatName: UILabel!
    @IBOutlet weak var imageSelected: UIImageView!
    
    func setData(seat: Seat) {
        seatName.text = seat.seatName
        imageSelected.isHidden = !seat.isSelected
    }
}
