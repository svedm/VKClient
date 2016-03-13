//
//  VKItem.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 10.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import Foundation

class VKItem: JSONConvertable {
    
    var type: String //TODO: to enum
    var sourceId: Int
    var date: NSDate
    var postId: Int
    var postType: String //TODO: to enum
    var text: String
    var friendsOnly : Bool
    //TODO var attachments
    //TODO post_source, likes, reposts
    
    
    
    required init(withJSON json: NSDictionary) {
        type = json.parseField(withName: "type", defaultValue: "")
        sourceId = json.parseField(withName: "source_id", defaultValue: 0)
        date = NSDate(timeIntervalSince1970: json.parseField(withName: "date", defaultValue: 0.0))
        postId = json.parseField(withName: "post_id", defaultValue: 0)
        postType = json.parseField(withName: "post_type", defaultValue: "")
        text = json.parseField(withName: "text", defaultValue: "")
        friendsOnly = Bool.init(json.parseField(withName: "friends_only", defaultValue: 0))
    }
}