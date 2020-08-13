//
//  ColorTableViewCell.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/15.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
