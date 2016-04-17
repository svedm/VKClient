//
//  VKFeedSources.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 17.04.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

class VKFeedSource {
    var id: NSNumber!
    var name: String
    var photo: String
    
    init(id: NSNumber!, name: String, photo: String) {
        self.id = id
        self.name = name
        self.photo = photo
    }
}
