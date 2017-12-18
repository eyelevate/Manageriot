//
//  RevokeTableViewCell.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/20/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit

class RevokeTableViewCell: UITableViewCell {


    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
