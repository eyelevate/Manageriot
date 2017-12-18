//
//  BeaconTableViewCell.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
