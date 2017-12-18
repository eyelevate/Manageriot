//
//  InventoryTableViewCell.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/4/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var missingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
