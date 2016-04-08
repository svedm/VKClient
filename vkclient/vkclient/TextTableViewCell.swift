//
//  BaseFeedTableViewCell.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 09.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var cellHeaderView: CellHeaderView!
    @IBOutlet weak var postText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func updateContent(title: String, date: NSDate, avatarUrl: NSURL, text: String) {
        cellHeaderView.avatarImageView.image = nil
        
        cellHeaderView.titleLabel.text = title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm dd.MM.yyyy"
        cellHeaderView.dateLabel.text = dateFormatter.stringFromDate(date)
        cellHeaderView.avatarImageView.af_setImageWithURL(avatarUrl)
        
        postText.text = text
    }
}
