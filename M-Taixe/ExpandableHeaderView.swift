//
//  ExpandableHeaderView.swift
//  TreeViewExample
//
//  Created by M on 1/16/18.
//  Copyright © 2018 M. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
    func headerSelected(indexSection: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    var button: UIButton!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.headerSelected(indexSection: cell.section)
    }
    
    func customInit(title: String, button: UIButton, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
        self.button = button
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowHideTable)))
    }
    
    @objc func ShowHideTable(section: Int) {
        if button.titleLabel?.text == "+" {
            self.button.setTitle("-", for: .normal)
        } else {
            self.button.setTitle("+", for: .normal)
        }
        
        delegate?.toggleSection(header: self, section: self.section)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.textColor = UIColor.black
        self.contentView.backgroundColor = UIColor.white
    }
}

