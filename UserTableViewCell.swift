//
//  UserTableViewCell.swift
//  machineTask_17_12_22
//
//  Created by Mac on 17/12/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
//MARK - IBOutlet connection of label
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
