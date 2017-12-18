//
//  Seat.swift
//  M-Taixe
//
//  Created by M on 12/10/17.
//  Copyright © 2017 kha. All rights reserved.
//

import Foundation
import HPXibDesignable
import HPUIViewExtensions

protocol SeatSelectDelegate {
    func seatSelect(index: Int, selected: Bool)
}

class SeatView: HPXibDesignable {
    
    // MARK: Storyboard Fields
    
    @IBOutlet weak var seatButton: HPButton!
    @IBOutlet weak var seatName: UILabel!
    @IBOutlet weak var seatStatus: UIImageView!
    
    @IBInspectable var isSelected: Bool = true {
        didSet {
            seatStatus.isHidden = !isSelected
        }
    }
    
    // MARK: User Actions
    
    var delegate: SeatSelectDelegate?
    var index: Int!

    @IBAction func seatSelect(_ sender: Any) {
        if let delegate = delegate {
            delegate.seatSelect(index: index, selected: isSelected)
        }
    }
    
    // MARK: Set data
    
    func setData(seat: Seat) {
        seatButton.bgColor = seat.isSelected  ? #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1) : #colorLiteral(red: 0.6255010657, green: 0.9064346326, blue: 0.9568627451, alpha: 1)
        seatStatus.isHidden = !seat.isSelected
        seatName.text = seat.seatName
    }
}
