//
//  TimeSheetTableViewCell.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/1/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
