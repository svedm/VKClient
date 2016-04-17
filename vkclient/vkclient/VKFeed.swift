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
    var nextFrom: String?
    
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
        
        nextFrom = json.parseField(withName: "next_from", defaultValue: "")
    }
    
    var vkFeedSources: [VKFeedSource]! {
        get {
            var sources = profiles.map { (user) -> VKFeedSource in
                return VKFeedSource(id: user.id, name: "\(user.first_name) \(user.last_name)", photo: user.photo_100)
            }
            
            sources.appendContentsOf(groups.map { (group) -> VKFeedSource in
                return VKFeedSource(id: Int(group.id) * -1, name: group.name, photo: group.photo_100)
            })
            
            return sources
        }
    }
}