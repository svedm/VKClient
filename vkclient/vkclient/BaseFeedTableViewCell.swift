//
//  BaseFeedTableViewCell.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 09.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

class BaseFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.text = "gfhgh"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
