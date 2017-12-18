//
//  SchemaViewController.swift
//  M-Taixe
//
//  Created by M on 12/11/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class SchemaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionSeatBotA: UICollectionView!
    @IBOutlet weak var collectionSeatBotB: UICollectionView!
    @IBOutlet weak var collectionSeatBotC: UICollectionView!
    @IBOutlet weak var collectionSeatBotD: UICollectionView!
    
    @IBOutlet weak var collectionSeatTopA: UICollectionView!
    
    @IBOutlet weak var collectionSeatTopB: UICollectionView!
    
    @IBOutlet weak var collectionSeatTopC: UICollectionView!
    
    @IBOutlet weak var collectionSeatTopD: UICollectionView!
    
    var listSeatA = [Seat]()
    var listSeatB = [Seat]()
    var listSeatC = [Seat]()
    var listSeatD = [Seat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBottomBar()
        setDataFromApi()
    }
    
    // MARK: - Init
    
    func initNavigationBottomBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let listCustomerButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ListIcon"), style: UIBarButtonItemStyle.plain, target: nil, action: #selector(SchemaViewController.btnListCustomerClick(_: )))
        let schemaButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let mapButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SchemaViewController.btnMapClick(_:)))
        schemaButton.tintColor = UIColor(netHex: 0x555555)
        listCustomerButton.tintColor = UIColor(netHex: 0x197DAE)
        
        let items = [flex, listCustomerButton, flex, schemaButton, flex, mapButton, flex]
        self.toolbarItems = items
    }
    
    func btnListCustomerClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnMapClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionSeatBotA:
            return listSeatA.count
        case collectionSeatBotB:
            return listSeatB.count
        case collectionSeatBotC:
            return listSeatC.count
        case collectionSeatBotD:
            return listSeatD.count
        case collectionSeatTopA:
            return listSeatA.count
        case collectionSeatTopB:
            return listSeatB.count
        case collectionSeatTopC:
            return listSeatC.count
        case collectionSeatTopD:
            return listSeatD.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionSeatBotA:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCellA", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatA[indexPath.row])
            
            return cell
        case collectionSeatBotB:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCellB", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatB[indexPath.row])
            
            return cell
        case collectionSeatBotC:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCellC", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatC[indexPath.row])
            
            return cell
        case collectionSeatBotD:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCellD", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatD[indexPath.row])
            
            return cell
        case collectionSeatTopA:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatTopCellA", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatA[indexPath.row])
            
            return cell
        case collectionSeatTopB:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatTopCellB", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatB[indexPath.row])
            
            return cell
        case collectionSeatTopC:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatTopCellC", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatC[indexPath.row])
            
            return cell
        case collectionSeatTopD:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatTopCellD", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatD[indexPath.row])
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCellD", for: indexPath) as! SeatCell
            cell.setData(seat: listSeatD[indexPath.row])
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionSeatBotA:
            print("Seat A Index = \(indexPath.row)")
        case collectionSeatBotB:
            print("Seat B Index = \(indexPath.row)")
        case collectionSeatBotC:
            print("Seat C Index = \(indexPath.row)")
        case collectionSeatBotD:
            print("Seat D Index = \(indexPath.row)")
        default:
            print("Seat defaul")
        }
    }
    
    func setDataFromApi () {
        let seatA1 = Seat(isSelected: true, seatName: "A1")
        let seatA2 = Seat(isSelected: false, seatName: "A2")
        let seatA3 = Seat(isSelected: true, seatName: "A3")
        let seatA4 = Seat(isSelected: false, seatName: "A4")
        let seatA5 = Seat(isSelected: false, seatName: "A5")
        listSeatA.append(seatA1)
        listSeatA.append(seatA2)
        listSeatA.append(seatA3)
        listSeatA.append(seatA4)
        listSeatA.append(seatA5)
        
        let seatB1 = Seat(isSelected: true, seatName: "B1")
        let seatB2 = Seat(isSelected: false, seatName: "B2")
        let seatB3 = Seat(isSelected: false, seatName: "B3")
        let seatB4 = Seat(isSelected: false, seatName: "B4")
        let seatB5 = Seat(isSelected: false, seatName: "B5")
        listSeatB.append(seatB1)
        listSeatB.append(seatB2)
        listSeatB.append(seatB3)
        listSeatB.append(seatB4)
        listSeatB.append(seatB5)
        
        let seatC1 = Seat(isSelected: true, seatName: "C1")
        let seatC2 = Seat(isSelected: false, seatName: "C2")
        let seatC3 = Seat(isSelected: false, seatName: "C3")
        let seatC4 = Seat(isSelected: false, seatName: "C4")
        let seatC5 = Seat(isSelected: false, seatName: "C5")
        listSeatC.append(seatC1)
        listSeatC.append(seatC2)
        listSeatC.append(seatC3)
        listSeatC.append(seatC4)
        listSeatC.append(seatC5)
        
        let seatD1 = Seat(isSelected: false, seatName: "D1")
        let seatD2 = Seat(isSelected: false, seatName: "D2")
        let seatD3 = Seat(isSelected: false, seatName: "D3")
        let seatD4 = Seat(isSelected: false, seatName: "D4")
        let seatD5 = Seat(isSelected: true, seatName: "D5")
        listSeatD.append(seatD1)
        listSeatD.append(seatD2)
        listSeatD.append(seatD3)
        listSeatD.append(seatD4)
        listSeatD.append(seatD5)
    }
}
