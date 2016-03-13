//
//  VKFeed.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 10.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import Foundation

class VKFeed: JSONConvertable {
    var items: [VKItem]
    
    required init(withJSON json: NSDictionary) {
        let vkItems = json["items"] as! NSArray
        
        items = [VKItem]()
        
        for item in vkItems {
            items.append(VKItem(withJSON: item as! NSDictionary))
        }
    }
}