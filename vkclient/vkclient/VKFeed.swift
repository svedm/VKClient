//
//  VKFeed.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 10.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKFeed: JSONConvertable {
    var items: [VKItem]
    var profiles: [VKUser] = []
    var groups: [VKGroup] = []
    
    required init(withJSON json: NSDictionary) {
        let vkItems = json["items"] as! NSArray
        
        items = [VKItem]()
        
        for item in vkItems {
            items.append(VKItem(withJSON: item as! NSDictionary))
        }
        
        let profilesArray = json.parseField(withName: "profiles", defaultValue: NSArray())
        for item in profilesArray {
            if let profileDictionary = item as? NSDictionary {
                if let profile = VKUser.init(dictionary: profileDictionary as [NSObject : AnyObject]) {
                    profiles.append(profile)
                }
            }
        }
        
        
        let groupsArray = json.parseField(withName: "groups", defaultValue: NSArray())
        for item in groupsArray {
            if let groupsDictionary = item as? NSDictionary {
                if let group = VKGroup.init(dictionary: groupsDictionary as [NSObject : AnyObject]) {
                    groups.append(group)
                }
            }
        }
    }
}