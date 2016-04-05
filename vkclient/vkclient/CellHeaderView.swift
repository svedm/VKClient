//
//  CellHeaderView.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 05.04.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

class CellHeaderView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("CellHeaderView", owner: self, options: nil)[0] as! UIView
        self.addSubview(self.view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterY , metrics: nil, views: ["view": self.view]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterX , metrics: nil, views: ["view": self.view]))
    }
}