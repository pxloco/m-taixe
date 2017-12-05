//
//  CustomerCell.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/15/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import MessageUI
class CustomerCell: UITableViewCell, MFMessageComposeViewControllerDelegate {
    var parent = CustomersController()
    @IBOutlet weak var lblCatchAddress: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerNumber: UILabel!
    
    
    var customerNumber = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCallClick(_ sender: UIButton) {
        var number = lblCustomerNumber.text ?? ""
        number = number.components(separatedBy: " - ")[0]
        makeCall(number)

    }
    func makeCall(_ tel: String){
        let trimmedString = tel.trimmingCharacters(in: CharacterSet.whitespaces)
        let telUrl:URL? = URL(string: "telprompt://"+tel)
        if ((telUrl) != nil){
            if(UIApplication.shared.canOpenURL(telUrl!)){
                UIApplication.shared.openURL(telUrl!)
            }else
            {
                print("Call not available")
            }
        }
    }
    @IBAction func btnSmsClick(_ sender: UIButton) {
        var number = lblCustomerNumber.text ?? ""
        number = number.components(separatedBy: " - ")[0]

        let ms = MFMessageComposeViewController()
        ms.messageComposeDelegate = self
        ms.recipients = [number]
        parent.navigationController?.present(ms, animated: true, completion: { 
            
        })
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            print("message canceled")
            
        case MessageComposeResult.failed.rawValue :
            print("message failed")
            
        case MessageComposeResult.sent.rawValue :
            print("message sent")
            
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    }
